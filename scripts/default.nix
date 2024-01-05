{ pkgs }:
{
  pushStore = pkgs.writeShellApplication {
    name = "push-store";
    runtimeInputs = with pkgs; [ jq ];
    text = ./push.sh;
  };
}
