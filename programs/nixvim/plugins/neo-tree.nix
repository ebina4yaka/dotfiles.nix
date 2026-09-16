{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];
      window = {
        position = "right";
      };
      filesystem = {
        follow_current_file = {
          enabled = true;
        };
        use_libuv_file_watcher = true;
      };
    };
  };
}
