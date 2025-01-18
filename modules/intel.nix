{
  config,
  pkgs,
  ...
}:
{
  config =
    let
      # Use the i915 driver for your Intel i7-10870H
      intel-vaapi-driver = (pkgs.intel-vaapi-driver or pkgs.vaapiIntel).override {
        enableHybridCodec = false; # Disable hybrid codec if not needed
      };
      intel-media-driver = pkgs.intel-media-driver;
      intel-compute-runtime = pkgs.intel-compute-runtime;
      vpl-gpu-rt = pkgs.vpl-gpu-rt or pkgs.onevpl-intel-gpu;
    in
    {
      # Ensure the i915 driver is loaded in the initrd
      boot.initrd.kernelModules = [ "i915" ];

      # Add required Intel GPU packages
      hardware.graphics.extraPackages = [
        intel-vaapi-driver
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];

      # Optionally add 32-bit versions if needed for compatibility
      hardware.graphics.extraPackages32 = [
        (pkgs.driversi686Linux.intel-vaapi-driver or pkgs.driversi686Linux.vaapiIntel)
        pkgs.driversi686Linux.intel-media-driver
      ];
    };
}
