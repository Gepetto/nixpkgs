{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  boost,
  cmake,
  doxygen,
  gepetto-viewer,
  omniorb,
  omniorbpy,
  python,
  pkg-config,
  libsForQt5,
}:

buildPythonPackage rec {
  pname = "gepetto-viewer-corba";
  version = "5.8.0";
  pyproject = false; # CMake

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer-corba";
    rev = "v${version}";
    hash = "sha256-/bpAs4ca/+QjWEGuHhuDT8Ts2Ggg+DZWETZfjho6E0w=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "ARGUMENTS $" "ARGUMENTS -p${omniorbpy}/${python.sitePackages} $" \
      --replace-fail '$'{CMAKE_SOURCE_DIR}/cmake '$'{JRL_CMAKE_MODULES}
  '';

  buildInputs = [ libsForQt5.qtbase ];

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    omniorb
    pkg-config
  ];

  propagatedBuildInputs = [
    gepetto-viewer
    boost
    omniorbpy
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/gepetto/gepetto-viewer-corba";
    description = "CORBA client/server for gepetto-viewer.";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
