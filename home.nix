{
  pkgs,
  username,
  homeDirectory,
  lib,
  ...
}:

let
  # Per-machine git identity lives OUTSIDE the repo (not committed) and is read
  # at eval time via --impure. Absent on machines that use the default identity.
  gitLocalPath = homeDirectory + "/.config/home-manager/git-local.nix";
  gitLocal = if builtins.pathExists gitLocalPath then import gitLocalPath else { };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage. These are passed in from flake.nix (resolved from $USER / $HOME).
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "26.11";

  home.packages = with pkgs; [
    gnused
    gawk
    elixir
    elixir-ls
    nodejs
    bruno-cli
    rustup
    bottom
    fzf
    lsd
    ripgrep
    git
    gh
    gcc
    nixfmt-tree
    gitu
    gnumake
    devenv
    grc
    fastfetch
    opencode
    onefetch
    nix-ld
    nixd
    inotify-tools
    pi-coding-agent
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
    ];
    NIX_LD = lib.getExe' pkgs.nix-ld "nix-ld";
  };

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "fzf";
        src = fzf.src;
      }
      {
        name = "pure";
        src = pure.src;
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
      {
        name = "enhancd";
        src = pkgs.fetchFromGitHub {
          owner = "b4b4r07";
          repo = "enhancd";
          rev = "v2.5.1";
          sha256 = "sha256-kaintLXSfLH7zdLtcoZfVNobCJCap0S/Ldq85wd3krI=";
        };
      }
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ebina4yaka";
        email = "ebina4yaka@protonmail.com";
      }
      // gitLocal;
      core.editor = "nvim";
      init.defaultBranch = "main";
      color.ui = "auto";
    };
  };
  imports = [
    ./programs/nixvim/nvim.nix
    ./programs/tmux/tmux.nix
    ./programs/herdr/herdr.nix
    ./programs/opencode/opencode.nix
    ./programs/gh/skills.nix
    ./programs/pi/pi.nix
  ];
}
