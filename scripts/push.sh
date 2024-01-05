SIGNING_KEY_PATH=$1
STORE_URL=$2

if [[ -z "$SIGNING_KEY_PATH" ]]; then
    echo "Must provide a key to sign the store path as the first argument" 1>&2
    exit 1
fi

if [[ -z "$STORE_URL" ]]; then
    echo "Must provide a url to push the paths as the second argument" 1>&2
    exit 1
fi

OUTPUTS=$(nix flake show --json --all-systems | jq -r '.packages."x86_64-linux" | keys | .[]')
for OUTPUT in $OUTPUTS
do
  STORE_PATH=$(sh -c "nix eval --raw .#$OUTPUT")
  echo "signing $STORE_PATH"
  nix store sign -k "$SIGNING_KEY_PATH" "$STORE_PATH" 
  echo "pushing $STORE_PATH to $STORE_URL"
  nix copy --to "$STORE_URL" "$STORE_PATH"
  echo "pushed $STORE_PATH to $STORE_URL"
done
