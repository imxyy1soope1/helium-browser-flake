closure=$(nix path-info -r ./result)
paths_to_copy=$(echo "$closure" | xargs -P $(nproc) -I {} bash -c '
  if ! nix-store --verify-path --store https://cache.nixos.org {} &>/dev/null; then
    echo {}
  fi
')

echo "The following paths will be copied to the new cache:"
echo "$paths_to_copy"
