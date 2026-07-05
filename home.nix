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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    rustup
    bottom
    fzf
    lsd
    ripgrep
    git
    gh
    gcc
    nixfmt
    nixfmt-tree
    gitu
    gnumake
    devenv
    grc
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
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
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ebina4yaka";
        email = "ebina4yaka@protonmail.com";
      }
      // gitLocal; # override name/email per machine if git-local.nix exists
      core.editor = "nvim";
      init.defaultBranch = "main";
      color.ui = "auto";
    };
  };
  imports = [
    ./programs/nixvim/nvim.nix
    ./programs/tmux/tmux.nix
  ];
}
