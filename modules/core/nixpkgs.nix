{ ... }:
{
  nixpkgs.config = {
    allowBroken = true;
    problems.handlers = {
      cups.broken = "warn";
    };
  };
  nixpkgs.overlays = [
    (final: prev: {
      gnugrep = prev.gnugrep.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];
}
