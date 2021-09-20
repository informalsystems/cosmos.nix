#! /usr/bin/env nix-shell
#! nix-shell --impure -p ghcid -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [turtle bytestring text aeson colourista unordered-containers pretty-simple foldl string-interpolate])" -i runhaskell

{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeApplications #-}

import Colourista
import qualified Control.Foldl as FLD
import Control.Monad
import Data.Aeson
import Data.Bifunctor
import qualified Data.ByteString.Lazy as BSL
import Data.Either
import qualified Data.HashMap.Strict as HM
import Data.Monoid
import Data.String.Interpolate
import qualified Data.Text as T
import GHC.Generics
import Text.Pretty.Simple (pPrint)
import Turtle
import qualified Turtle.Bytes as TB
import Prelude

data GoSource = GoSource {sourceName :: Text, inputName :: Text, storePath :: Text} deriving (Show)

data GoSourceDetailed = GoSourceDetailed
  { detailedSourceName :: Text,
    detailedInputName :: Text,
    detailedStorePath :: Text,
    detailedLockDetails :: LockDetails
  }
  deriving (Show)

newtype Nodes = Nodes {nodes :: Object} deriving (Generic, FromJSON, Show)

newtype NodeDetails = NodeDetails {locked :: LockDetails} deriving (Generic, FromJSON, Show)

data LockType = Github | Other Text deriving (Show)

instance FromJSON LockType where
  parseJSON (String "github") = pure Github
  parseJSON (String t) = pure $ Other t
  parseJSON v = fail $ "Failed to parse LockType from JSON, expected a String but got: " <> show v

data LockDetails = LockDetails
  { ldNarHash :: Text,
    ldOwner :: Text,
    ldRepo :: Text,
    ldRev :: Text,
    ldType :: LockType
  }
  deriving (Show)

instance FromJSON LockDetails where
  parseJSON = withObject "LockDetails" $ \v ->
    LockDetails
      <$> v .: "narHash"
      <*> v .: "owner"
      <*> v .: "repo"
      <*> v .: "rev"
      <*> v .: "type"

main :: IO ()
main = sh $ do
  inputs <- stdin
  flakeLock <- TB.strict . TB.input $ "flake.lock"
  let goSources = parseInputs <$> T.words (lineToText inputs)

  when (any (\GoSource {..} -> T.null storePath) goSources) $
    liftIO $ do
      errorMessage "One or more go sources are missing nix store paths"
      pPrint goSources
      exit $ ExitFailure 126

  (missingSrcs, foundSrcs) <-
    partitionEithers
      <$> case eitherDecode . BSL.fromStrict $ flakeLock of
        Left e -> do
          liftIO $ errorMessage "Could not parse flake.lock file! It appears to be in an invalid state."
          liftIO . pPrint $ "aeson failed with this message: \n" <> e
          liftIO . exit $ ExitFailure 126
        Right (Nodes nodes) ->
          pure $
            goSources <&> \GoSource {..} ->
              GoSourceDetailed sourceName inputName storePath
                <$> (nodesLookup inputName nodes >>= (fmap locked . resultToEitherText . fromJSON @NodeDetails))

  when (not . null $ missingSrcs) $
    liftIO $ do
      forM missingSrcs (\err -> errorMessage err)
      exit $ ExitFailure 126

  syncedSources <- forM foundSrcs updateGoModules

  liftIO $ do
    putStrLn "\n"
    putStrLn $ formatWith [bold] "Done syncing go modules:"
    forM syncedSources notifyUpdated

  exit $ ExitSuccess

parseInputs :: Text -> GoSource
parseInputs =
  (\(sourceName, (inputName, storePath)) -> GoSource {..})
    . fmap (T.breakOn "/" . T.drop 1)
    . T.breakOn ":"

data HasSyncedModules = Updated | Cached deriving (Show)

updateGoModules :: GoSourceDetailed -> Shell (HasSyncedModules, Text)
updateGoModules GoSourceDetailed {..} = do
  let LockDetails {..} = detailedLockDetails
      goSrcDir = "./" <> fromText detailedSourceName
      narFile = goSrcDir <> "last-synced.narHash"
  hasNarFile <- fold ((\p -> Any $ p == narFile) <$> ls goSrcDir) FLD.mconcat

  let narHashIsEqual = input narFile <&> \hash -> Any $ (lineToText hash) == ldNarHash
  shouldSync <- msum [pure $ negateAny hasNarFile, narHashIsEqual]

  if getAny shouldSync
    then do
      sourceHome <- pwd
      tmp <- mktempdir sourceHome "./tmp"
      cd tmp
      cptreeL (fromText detailedStorePath) "./"
      proc "gomod2nix" [] mempty
      cd sourceHome
      mktree goSrcDir
      mv (tmp <> "gomod2nix.toml") (goSrcDir <> "go-modules.toml")
      output narFile (pure $ unsafeTextToLine ldNarHash)
      pure (Updated, detailedSourceName)
    else pure (Cached, detailedSourceName)

notifyUpdated :: (HasSyncedModules, Text) -> IO ()
notifyUpdated (Updated, name) =
  successMessage $ name <> "'s go modules were updated."
notifyUpdated (Cached, name) =
  skipMessage $ name <> " has up to date go modules."

negateAny :: Any -> Any
negateAny (Any True) = Any False
negateAny (Any False) = Any True

resultToEitherText :: Result a -> Either Text a
resultToEitherText (Success a) = Right a
resultToEitherText (Error str) = Left $ T.pack str

nodesLookup :: Text -> Object -> Either Text Value
nodesLookup name nodes =
  case HM.lookup name nodes of
    Nothing -> Left $ "Couldn't find " <> name <> " in nodes"
    Just a -> Right a
