{
  pkgs,
  lib,
  ...
}: {
  environment.shellAliases = let
  in {
    # things I do to keep my home directory clean
    wget = "wget --hsts-file='\${XDG_DATA_HOME}/wget-hsts'";

    # init a LICENSE file with my go-to gpl3 license
    "gpl" = "${lib.getExe pkgs.curl} https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
  };
}
