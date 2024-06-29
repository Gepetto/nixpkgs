{
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,
  lib,
  boost,
  cmake,
  darwin,
  doxygen,
  jrl-cmakemodules,
  libsForQt5,
  openscenegraph,
  osgqt,
  pkg-config,
  python-qt,
  qgv,
}:
buildPythonPackage rec {
  pname = "gepetto-viewer";
  version = "5.1.0";
  pyproject = false; # CMake

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer";
    rev = "v${version}";
    hash = "sha256-A2J3HidG+OHJO8LpLiOEvORxDtViTdeVD85AmKkkOg8=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PY_QCUSTOM_PLOT" (!stdenv.isDarwin))
    (lib.cmakeBool "BUILD_PY_QGV" (!stdenv.isDarwin))
  ];

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    boost
    python-qt
    libsForQt5.qtbase
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ darwin.autoSignDarwinBinariesHook ];

  propagatedBuildInputs = [
    jrl-cmakemodules
    openscenegraph
    osgqt
    qgv
  ];

  doCheck = true;

  # wrapQtAppsHook uses isMachO, which fails to detect binaries without this
  # ref. https://github.com/NixOS/nixpkgs/pull/138334
  preFixup = lib.optionalString stdenv.isDarwin "export LC_ALL=C";

  meta = {
    description = "Graphical Interface for Pinocchio and HPP.";
    homepage = "https://github.com/gepetto/gepetto-viewer";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.nim65s ];
    mainProgram = "gepetto-gui";
  };
}
