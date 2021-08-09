#! /usr/bin/env nix-shell
#! nix-shell --impure -p ghcid -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [turtle bytestring text aeson colourista unordered-containers pretty-simple foldl string-interpolate])" -i runhaskell

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE QuasiQuotes #-}

import Prelude
import Control.Monad
import Turtle
import Data.Either
import qualified Turtle.Bytes as TB
import qualified Data.ByteString.Lazy as BSL
import qualified Data.Text as T
import Data.Aeson
import qualified Data.HashMap.Strict as HM
import GHC.Generics
import Colourista
import Text.Pretty.Simple (pPrint)
import Data.Monoid
import qualified Control.Foldl as FLD
import Data.String.Interpolate

data GoSource = GoSource { sourceName :: Text, storePath :: Text } deriving Show
data GoSourceDetailed =
  GoSourceDetailed
    { detailedSourceName :: Text
    , detailedStorePath :: Text
    , detailedLockDetails :: LockDetails
    } deriving Show

newtype Nodes = Nodes { nodes :: Object } deriving (Generic, FromJSON, Show)
newtype NodeDetails = NodeDetails { locked :: LockDetails } deriving (Generic, FromJSON, Show)

data LockType = Github | Other Text deriving (Show)
instance FromJSON LockType where
  parseJSON (String "github") = pure Github
  parseJSON (String t) = pure $ Other t
  parseJSON v = fail $ "Failed to parse LockType from JSON, expected a String but got: " <> show v

data LockDetails =
  LockDetails
    { ldNarHash :: Text
    , ldOwner :: Text
    , ldRepo :: Text
    , ldRev :: Text
    , ldType :: LockType
    } deriving Show

instance FromJSON LockDetails where
  parseJSON = withObject "Coord" $ \v -> LockDetails
        <$> v .: "narHash"
        <*> v .: "owner"
        <*> v .: "repo"
        <*> v .: "rev"
        <*> v .: "type"

main :: IO ()
main = sh $ do
  inputs <- stdin
  flakeLock <- TB.input "flake.lock"
  let goSources = uncurry GoSource . T.breakOn "/" <$> T.words (lineToText inputs)
  liftIO $ print goSources

  when (any (\GoSource{..} -> T.null storePath) goSources) $ liftIO $ do
    errorMessage "One or more go sources are missing nix store paths"
    pPrint goSources
    exit $ ExitFailure 126

  (missingSrcs, foundSrcs) <- partitionEithers <$>
    case decode . BSL.fromStrict $ flakeLock of
      Nothing -> do
        liftIO $ errorMessage "Could not parse flake.lock file! It appears to be in an invalid state."
        liftIO . exit $ ExitFailure 126
      Just (Nodes nodes) ->
        pure $ goSources <&> \GoSource{..} ->
          GoSourceDetailed sourceName storePath <$>
            (nodesLookup sourceName nodes >>= (fmap locked . resultToEitherText . fromJSON @NodeDetails))

  when (not . null $ missingSrcs) $ liftIO $ do
    forM missingSrcs (\err -> errorMessage err)
    exit $ ExitFailure 126

  forM foundSrcs updateGoModules

  exit $ ExitSuccess

data HasSyncedModules = Updated | Cached

updateGoModules :: GoSourceDetailed -> Shell (HasSyncedModules, Text)
updateGoModules GoSourceDetailed{..} = do
  let LockDetails{..} = detailedLockDetails
      goSrcDir = "./" <> fromText ldRepo
      narFile = goSrcDir <> "last-synced.nar"
  hasNarFile <- fold ((\p -> Any $ p == narFile) <$> ls goSrcDir) FLD.mconcat

  let narHashIsEqual = input narFile <&> \hash -> Any $ (lineToText hash) == ldNarHash
  shouldSync <- msum [ pure $ negateAny hasNarFile, narHashIsEqual]
  liftIO $ print shouldSync

  if getAny shouldSync
     then do
       sourceHome <- pwd
       tmp <- mktempdir sourceHome "./tmp"
       cd tmp
       cptreeL (fromText detailedStorePath) "./"
       proc "gomod2nix" [] mempty

       cd sourceHome
       mv (collapse $ tmp <> "./gomod2nix.toml") (collapse $ goSrcDir <> "./go-modules.toml")
       output (collapse $ goSrcDir <> "./last-synced.nar") (pure $ unsafeTextToLine ldNarHash)
       pure (Updated, detailedSourceName)
     else pure (Cached, detailedSourceName)

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

(<$$>) :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
(<$$>) f fga = fmap f <$> fga
