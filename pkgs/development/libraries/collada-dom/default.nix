{ stdenv, lib, fetchFromGitHub, cmake, boost, libxml2, minizip, readline }:

stdenv.mkDerivation {
  pname = "collada-dom";
  version = "unstable-2024-07-23";

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "collada-dom";
    rev = "ec585debce96e4c9ffec978eec6f794218f67bbe";
    sha256 = "sha256-nPh0z3RKCJUG+BU4kNqCLUXoqxmMjOKAkMWjq7Kvolk=";
  };

  postInstall = ''
    chmod +w -R $out
    ln -s $out/include/*/* $out/include
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libxml2
    minizip
    readline
  ];

  meta = with lib; {
    description = "Lightweight version of collada-dom, with only the parser.";
    homepage = "https://github.com/gepetto/collada-dom";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.all;
  };
}
