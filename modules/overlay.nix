# Provides an overlay for other flakes to consume and get all the cosmos packages in their pkgs 
# https://flake.parts/overlays.html?highlight=overlay#defining-an-overlay
{ withSystem, ...}:
{
  flake.overlays.default = final: prev: 
    withSystem prev.stdenv.hostPlatform.system ({self', ...} : self'.packages);
}
