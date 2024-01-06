def main [key_path: string, store_url: string] {
  print $"($key_path)"
  print $"($store_url)"

  let outputs: string = (nix flake show --json --all-systems | jq -r '.packages."x86_64-linux" | keys | .[]')

  $"($outputs)" | split row "\n" | par-each { |output|
    print $"[($output)]: evaluating store path"
    let store_path = (nix eval --raw $".#($output)")
    print $"[($output)]: evaluated to ($store_path)"
    print $"[($output)]: signing"
    nix store sign -r -k $"($key_path)" $"($store_path)"
    print $"[($output)]: signed and pushing ($store_path)"
    nix copy --to $"($store_url)" $"($store_path)"
    print $"[($output)]: pushed"
  }
}
