{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  # herdr has no declarative option for plugins: registration lives in
  # ~/.config/herdr/plugins.json, which herdr owns and rewrites itself (on
  # enable/disable and on `plugin install`), so we cannot hand it a read-only
  # symlink from the store. Instead we keep the source of truth here and drive
  # the CLI from an activation hook. `herdr plugin link <dir>`:
  #
  #   * replaces the registry entry for that plugin id, so re-running is
  #     idempotent (src/cli/plugin.rs, src/persist/plugin_registry.rs)
  #   * runs no [[build]] commands, unlike `plugin install` (which also clones
  #     from GitHub, i.e. fetches outside of Nix)
  #   * works with the herdr server stopped, and goes over the socket when it is
  #     running, so plugins show up without a restart
  #
  # Plugin commands run with cwd = plugin_root and get HERDR_PLUGIN_CONFIG_DIR /
  # HERDR_PLUGIN_STATE_DIR for anything they need to write, so a read-only
  # /nix/store root is fine. Plugins that build or cache inside their own
  # checkout need a real derivation (fetchFromGitHub + buildRustPackage etc.)
  # instead of the bare source input used below.
  #
  # Sources are `flake = false` inputs, so they are pinned in flake.lock, updated
  # with `nix flake update`, and picked up by the dependabot nix group.
  pluginRoots = [
    # fzf palette over every action of every installed plugin. Pure bash; bound
    # to prefix+a in herdr.nix. Needs fzf, which home.nix already installs.
    "${inputs.herdr-command-palette}"
  ];

  herdrBin = "${pkgs.herdr}/bin/herdr";
  registry = "${config.xdg.configHome}/herdr/plugins.json";
  linkPlugin = root: ''
    run ${herdrBin} plugin link ${lib.escapeShellArg root} \
      || echo "herdr: failed to link plugin ${root}" >&2
  '';
in
{
  home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Unlink plugins that were linked from the store by a previous generation but
    # are no longer declared above. `plugin unlink` only deregisters; it never
    # touches files, and it leaves the plugin's config/state dirs alone.
    if [ -e ${lib.escapeShellArg registry} ]; then
      herdrStalePlugins=$(${pkgs.jq}/bin/jq -r \
        --argjson declared ${lib.escapeShellArg (builtins.toJSON pluginRoots)} \
        '.[]
         | select(.source.kind == "local")
         | select(.plugin_root | startswith("/nix/store/"))
         | select([.plugin_root] - $declared | length > 0)
         | .plugin_id' ${lib.escapeShellArg registry})
      for herdrPluginId in $herdrStalePlugins; do
        run ${herdrBin} plugin unlink "$herdrPluginId" \
          || echo "herdr: failed to unlink plugin $herdrPluginId" >&2
      done
    fi

    ${lib.concatMapStrings linkPlugin pluginRoots}
  '';
}
