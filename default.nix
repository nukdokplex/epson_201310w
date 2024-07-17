{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "epson_201310w";
  version = "1.0.1";

  src = pkgs.fetchurl {
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/15/64/77/a25bcc458699e11aef84771caf6076628d56bf01/epson-inkjet-printer-201310w-${version}-1.x86_64.rpm"
      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/15/64/77/a25bcc458699e11aef84771caf6076628d56bf01/epson-inkjet-printer-201310w-${version}-1.x86_64.rpm"
    ];
    hash = "sha256-uapglDUSwGzDyJ0lOAK2bHtY9jeGWjnHD1V28aaCVPk=";
  };

  dontBuild = true;
  nativeBuildInputs = with pkgs; [ rpmextract gzip ];
  unpackPhase = ''
    rpmextract $src
    cd opt/epson-inkjet-printer-201310w
    gzip --decompress ppds/Epson/Epson-L120_Series-epson-driver.ppd.gz
    substituteInPlace ppds/Epson/Epson-L120_Series-epson-driver.ppd --replace "/opt/epson-inkjet-printer-201310w/cups/lib/filter" "$out/cups/lib/filter"
    substituteInPlace ppds/Epson/Epson-L120_Series-epson-driver.ppd --replace "/home/epson/projects/PrinterDriver/P2/_rpmbuild/SOURCES/epson-inkjet-printer-201310w-1.0.1/watermark" "$out/watermark"
  '';

  postInstall = ''
    mkdir -p $out/share/cups/model/epson-inkjet-printer-201310w
    cp -a ppds $out/share/cups/model/epson-inkjet-printer-201310w
    cp -a doc lib64 resource watermark $out
    mkdir -p $out/lib/cups/filter
    cp -a cups/lib/filter/epson_inkjet_printer_filter $out/lib/cups/filter
  '';
}
