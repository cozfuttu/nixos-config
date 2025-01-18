{ pkgs }:

pkgs.writeShellScriptBin "set-brighness" ''
  BRIGHTNESS_PATH="/sys/class/backlight/intel_backlight/brightness"
  echo "$1" | sudo tee "$BRIGHTNESS_PATH" > /dev/null

  echo "Brightness set to $1"
''
