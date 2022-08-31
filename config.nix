{
  permittedInsecurePackages = [ "openssl-1.0.2u" ];
  allowUnfree = true;

  retroarch = {
    enableParallelN64 = true;
  };

  firefox = {
    #enableAdobeFlash = true;
    #icedtea = true;
  };

  requireSignedBinaryCaches = false;
  #trusted-binary-caches = [ https://bob.logicblox.com/ ]
  #extra-binary-caches = [ https://bob.logicblox.com/ ]

  packageOverrides = pkgs: rec {
    my-env = import ./env.nix pkgs;
    #mpsyt = pkgs.python3Packages.mps-youtube.override { youtube-dl = my-youtube-dl; };
    mps-youtube = pkgs.mps-youtube.overrideAttrs (oldAttrs: rec {
      patches = [ ./mpsyt-data-none.patch ];
    });

    #mpv = pkgs.mpv.override { youtube-dl = my-youtube-dl; };
    my-youtube-dl = pkgs.youtube-dl.overrideAttrs (oldAttrs: rec {
      version = "2019.04.30";
      name = "youtube-dl-${version}";
      src = pkgs.fetchurl {
        url = "https://yt-dl.org/downloads/${version}/${name}.tar.gz";
        sha256 = "1s43adnky8ayhjwmgmiqy6rmmygd4c23v36jhy2lzr2jpn8l53z1";
      };
    });

    pidgin-with-plugins = pkgs.pidgin.override {
      plugins = [ pkgs.pidgin-otr pkgs.pidgin-osd pkgs.purple-hangouts pkgs.purple-googlechat ];
    };

    kepubify = pkgs.buildGoModule rec {
      name = "kepubify-${version}";
      version = "v2.3.3";

      src = pkgs.fetchFromGitHub {
        owner = "geek1011";
        repo = "kepubify";
        rev = version;
        sha256 = "1k8ips0dkbg607v81vjw3q86h3ls7mrpx62nhw6wsmix3cssms7y";
      };

      vendorSha256 = "0ckc5r5r9hl6wf8dcsmgr1vmrfccmjfbzspkksjbbc422f6g2lxr";

      meta = with pkgs.lib; {
        description = "Convert epubs to kepubs";
        homepage = https://pgaskin.net/kepubify/;
        license = licenses.mit;
        platforms = platforms.linux;
      };
    };

    /*firefox-32bit = let
      pkgsi686Linux = pkgs.forceSystem "i686-linux" "i386";
      firefoxPackages = (pkgs.callPackage <nixpkgs>/pkgs/applications/networking/browsers/firefox/packages.nix {
        callPackage = with pkgs; pkgsi686Linux.newScope {
          inherit (gnome2) libIDL;
          libpng = libpng_apng;
          python = python2;
          gnused = gnused_422;
          icu = icu59;
        };
      });
      firefox-unwrapped = firefoxPackages.firefox;
      in pkgs.wrapFirefox firefox-unwrapped { };*/

    headoverheals = pkgs.stdenv.mkDerivation {
      name = "head-over-heels";
      src = pkgs.fetchurl {
        url = "http://www.headoverheels2.com/descargas/headoverheels-1.0.1.tar.bz2";
				sha256 = "1vnykwwrv75miigbhmcwxniw8xnhsdyzhqydip2m9crxi2lwhqs9";
      };

      buildInputs = with pkgs; with xlibs; [ pkgconfig libX11 libXcomposite libXdamage libXrender ];

      installPhase = ''
        mkdir -p $out/bin
        cp transset-df $out/bin/
        '';
    };


    neovim = let
      coquille = pkgs.vimUtils.buildVimPlugin {
        name = "coquille";
        src = /home/edanaher/fun/coq/vim/coquille;
      };
      neovim-coq = pkgs.vimUtils.buildVimPlugin {
        name = "neovim-coq";
        src = /home/edanaher/fun/coq/vim/neovim-coq;
      };
      vimbufsync = pkgs.vimUtils.buildVimPlugin {
        name = "vimbufsync";
        src = /home/edanaher/fun/coq/vim/vimbufsync;
      };
      nv-coq = pkgs.vimUtils.buildVimPlugin {
        name = "nv-coq";
        src = /home/edanaher/fun/coq/vim/nv-coq;
      };
    in
    pkgs.neovim.override {
      configure = {
        customRC = ''source ~/.config/nvim/init.vim'';
#        packages.myVimPackage = with pkgs.vimPlugins; {
#          start = [
#            vim-airline
#            vim-highlightedyank
#            Solarized
#          ];
#        };
        vam = {
          knownPlugins = pkgs.vimPlugins // { inherit coquille neovim-coq vimbufsync nv-coq; };
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
            #{ name = "vim-multiple-cursors"; }
            #{ name = "coquille"; }
            #{ name = "neovim-coq"; }
            { name = "Coqtail"; }
            #{ name = "nv-coq"; }
            { name = "vimbufsync"; }
            # { name = "YankRing"; }
          ];
        };
      };
    };

    hoogle = (pkgs.haskellPackages.extend (self: super: {
      /*hslua = super.hslua.override {
        lua5_1 = pkgs.lua5_3;
      };*/
    })).ghcWithHoogle (haskellPackages: 
      with haskellPackages; [ hslua lens yesod yesod-auth persistent frisby /*amazonka*/ conduit optparse-simple rio ]
    );

    transset-df = pkgs.stdenv.mkDerivation {
      name = "transset-df";
      src = pkgs.fetchurl {
        url = "http://forchheimer.se/transset-df/transset-df-6.tar.gz";
				sha256 = "1vnykwwrv75miigbhmcwxniw8xnhsdyzhqydip2m9crxi2lwhqs5";
      };

      buildInputs = with pkgs; with xlibs; [ pkgconfig libX11 libXcomposite libXdamage libXrender ];

      installPhase = ''
        mkdir -p $out/bin
        cp transset-df $out/bin/
        '';
    };

    antimicro = pkgs.stdenv.mkDerivation rec {
      name = "${pname}-${version}";
      pname = "antimicro";
      version = "2.23";
      src = pkgs.fetchurl {
        url = "https://github.com/AntiMicro/antimicro/archive/2.23.tar.gz";
				sha256 = "1vx94zczjrxbxnpmcs45l1s332pk7fbz354i5ychba1dc5q92c7g";
      };

      buildInputs = with pkgs; [ cmake pkgconfig SDL2 qt4 xorg.libXtst];

      buildPhase = ''ls'';

#      installPhase = ''
#        mkdir -p $out/bin
#        cp transset-df $out/bin/
#        '';
    };
    
   /* new-looking-glass-client = pkgs.looking-glass-client.overrideAttrs (oldAttrs: rec {
      version = "B2-rc3";

      src = pkgs.fetchFromGitHub {
        owner = "gnif";
        repo = "LookingGlass";
        rev = version;
        sha256 = "07nvvmmggs1vn6rl04li018aa3qs9p1lssl2dl85gm09a939l407";
      };

      # src = pkgs.fetchgit {
      #   url = "https://github.com/gnif/LookingGlass.git";
      #   rev = version;
      #   sha256 = "10y5vsw5b0gcyvcgk3s9rx36vs6jhpszmlw7l3my8nbp8s7yk4pk";
      #   fetchSubmodules = true;
      # };

      patchPhase = ''echo MAGIC; pwd '';

      buildInputs = oldAttrs.buildInputs ++ [ pkgs.expat pkgs.libffi pkgs.xlibs.libXi ];
    });*/

    maven = pkgs.maven.override {
      jdk = pkgs.jdk11;
    };

    /*streamlink-twitch-gui = pkgs.stdenv.mkDerivation rec {
      pname = "streamlink-twitch-gui";
      version = "1.5.0";

      name = "${pname}-${version}";

      src = pkgs.fetchFromGitHub {
        owner = "streamlink";
        repo = "${pname}";
        rev = "v${version}";
				sha256 = "12859y1d261lcxwp22nbbyrhgwxv1dkzx96m13979mw049i2s55q";
      };

      buildInputs = with pkgs; with nodePackages; [ grunt-cli nodejs ];

      buildPhase = ''
        grunt build
      '';

      installPhase = ''
        mkdir -p $out
        cp -a * $out
      '';
    };*/

    my-flashplayer = pkgs.lib.overrideDerivation pkgs.flashplayer (oldAttrs: rec {
      name = "flashplayer-${version}";
      version = "32.0.0.453";
      src = pkgs.fetchurl {
        url = "http://fpdownload.adobe.com/get/flashplayer/pdc/${version}/flash_player_npapi_linux.x86_64.tar.gz";
        sha256 = "1apgikb8rsmgmfkk9mcffslkww9jj5wgi998imaqgr7ibyfl19bk";
      };
    });

      xmlcutty = pkgs.buildGoPackage rec {
        name = "xmlcutty-${version}";
        version = "0.1.5";

        goPackagePath = "github.com/miku/xmlcutty";

        src = pkgs.fetchFromGitHub {
          owner = "miku";
          repo = "xmlcutty";
          rev = "v${version}";
          sha256 = "01kfqlhkyc61x51498lvb2dbf5kl54b38jj35a5ibhvngy3g5q5i";
        };
      };

      straw-viewer = pkgs.buildPerlPackage rec {
        pname = "straw-viewer";
        version = "0.0.3";
        src = pkgs.fetchFromGitHub {
          owner = "trizen";
          repo = pname;
          rev = version;
          sha256 = "1qidpiil11qbfnsxr7an269gz4m99vazsxq3f3iy5982a90fnhig";
        };

        propagatedBuildInputs = with pkgs.perlPackages; [
          DataDump URI LWP LWPProtocolHttps JSON
        ];
      };

    interception = pkgs.stdenv.mkDerivation rec {
      pname = "interception";
      version = "0.6.3";

      name = "${pname}-${version}";

      buildInputs = with pkgs; [cmake boost libudev libyamlcpp libevdev];

      src = pkgs.fetchFromGitLab {
        owner = "interception";
        repo = "linux/tools";
        rev = "v${version}";
				sha256 = "00h0xqdkgb6q7sc4vy22vjfyvwy43sns571dbxwwsh86v1znwjxi";
      };

    };

    libevdev = pkgs.lib.overrideDerivation pkgs.libevdev (oldAttrs: rec {
      postInstall = ''
        ln -s $out/include/libevdev-1.0/libevdev $out/include/
      '';
    });

    #mach-nix.buildPythonPackage "https://github.com/psf/requests/tarball/2a7832b5b06d";

    #apache-superset-python = pkgs.python39.withPackages (ps: with ps; [
    #  (ps : ps.callPackage ./superset-dependencies.nix {})
    #]);
    #apache-superset = apache-superset-python.pkgs.buildPythonApplication rec {
    #  pname = "apache-superset";
    #  version = "2.0.0";
    #  src = pkgs.fetchurl {
    #    url = "https://downloads.apache.org/superset/2.0.0/apache-superset-2.0.0-source.tar.gz";
    #    hash = "sha256-ejmOpQxCzo7uCOtjW5NgU5s2JjxXWJFw6aF+twi2FHc";
    #  };

    #  propagetedBuildInputs = let deps = let deps-rec = (import ./superset-dependencies.nix) {
    #    pkgs = pkgs;
    #    fetchurl = pkgs.fetchurl;
    #    fetchgit = pkgs.fetchgit;
    #    fetchhg = pkgs.fetchhg;
    #  }; in deps-rec pkgs deps-rec;
    #  in
    #  with apache-superset-python.pkgs;
    #  [ pgsanity cron-descriptor ];
    #};



    #  meta = with pkgs.lib; {
    #    description = "A modern, enterprise-ready business intelligence web application.";
    #    homepage = "https://superset.apache.org/";
    #    #license = licenses.apache2;
    #    maintainers = with maintainers; [ edanaher ];
    #    platforms = platforms.linux;
    #  };

    #};
  };
  useSandbox = false;
  build-use-sandbox = false;

}
