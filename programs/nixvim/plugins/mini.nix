{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      ai = {
        enable = true;
        settings = {
          n_lines = 500;
        };
      };
      pairs = {
        enable = true;
      };
    };
  };
}
