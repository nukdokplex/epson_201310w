{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "epson_201310w";
  version = "1.0.1";

  src = pkgs.fetchurl {
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/15/64/77/6f825c323a9f4b8429e3f9f0f4e9c50b1b15f583/epson-inkjet-printer-201310w-${version}-1.src.rpm"
      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/15/64/77/6f825c323a9f4b8429e3f9f0f4e9c50b1b15f583/epson-inkjet-printer-201310w-${version}-1.src.rpm"
    ];
    hash = "sha256-596qMon5KmMHe7mh+ykdpWeazJOCGA6HmmtvdGheRmA=";
  };
  
  nativeBuildInputs = with pkgs; [ rpmextract autoreconfHook file ];
  buildInputs = with pkgs; [ libjpeg cups ];

  unpackPhase = ''
    rpmextract $src
    tar -zxf epson-inkjet-printer-201310w-1.0.1.tar.gz
    tar -zxf epson-inkjet-printer-filter-1.0.2.tar.gz
    substituteInPlace epson-inkjet-printer-201310w-1.0.1/ppds/EPSON_L120.ppd --replace "/home/epson/projects/PrinterDriver/P2/_rpmbuild/SOURCES/epson-inkjet-printer-201310w-1.0.1/watermark" "$out/watermark"
    cd epson-inkjet-printer-filter-1.0.2
  '';

  preConfigure = ''
    chmod +x configure
    export LDFLAGS="$LDFLAGS -Wl,--no-as-needed"
  '';

  postInstall = ''
    cd ../epson-inkjet-printer-201310w-1.0.1
    cp -a lib64 resource watermark $out
    mkdir -p $out/share/cups/model
    cp -a ppds/EPSON_L120.ppd $out/share/cups/model
    mkdir -p $out/doc
    cp -a Manual.txt $out/doc
    cp -a README $out/doc/README.driver
  '';
}
