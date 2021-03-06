{
  allowUnfree = true;

  firefox = {
    enableAdobeFlash = true;
    icedtea = true;
  };

  requireSignedBinaryCaches = false;
  #trusted-binary-caches = [ https://bob.logicblox.com/ ]
  #extra-binary-caches = [ https://bob.logicblox.com/ ]

  packageOverrides = pkgs: rec {
    pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
      plugins = [ pkgs.pidginotr pkgs.pidginosd ];
    };

    neovim = pkgs.neovim.override {
      configure = {
        customRC = ''source ~/.config/nvim/init.vim'';
        vam = {
          pluginDictionaries = [
            { name = "ctrlp"; }
            { name = "vim-lawrencium"; }
            { name = "fugitive"; }
            { name = "deoplete-nvim"; ft_regex = "^vim$"; }
            { name = "deoplete-jedi"; ft_regex = "^python$"; }
            { name = "neco-vim"; }
            { name = "vim-scala"; }
            { name = "vim2nix"; }
            { name = "Solarized"; }
            { name = "vim-nix"; }
            { name = "vim-airline"; }
            { name = "vim-airline-themes"; }
            { name = "vim-highlightedyank"; }
            # { name = "YankRing"; }
          ];
        };
      };
    };
  };
}
