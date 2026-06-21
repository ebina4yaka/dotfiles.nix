{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];
    };
  };
}
