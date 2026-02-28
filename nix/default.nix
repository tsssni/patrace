{
  androidenv,
  cmake,
  gradle_6,
  hdf5,
  jdk8,
  lib,
  libX11,
  libtiff,
  ninja,
  pkg-config,
  postgresql,
  python3,
  qt5,
  stdenv,
  subversion,
  swig,
}:
let
  androidComposition = androidenv.composeAndroidPackages {
    platformVersions = [
      "29"
      "30"
    ];
    buildToolsVersions = [
      "29.0.2"
      "30.0.3"
    ];
    includeNDK = true;
    ndkVersions = [ "21.1.6352462" ];
    cmakeVersions = [ "3.22.1" ];
  };
  androidSdk = androidComposition.androidsdk;
in
stdenv.mkDerivation {
  pname = "patrace";
  version = "dev";

  src = ../.;
  # src = fetchFromGitHub {
  #   owner = "ARM-software";
  #   repo = "patrace";
  #   rev = "";
  #   sha256 = "";
  # };

  nativeBuildInputs = [
    androidSdk
    cmake
    gradle_6
    jdk8
    ninja
    pkg-config
    (python3.withPackages (
      ps: with ps; [
        setuptools
        pip
        wheel
      ]
    ))
    subversion
    swig
  ];

  buildInputs = [
    hdf5
    libX11
    libtiff
    postgresql
    qt5.qtbase
  ];

  env = rec {
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    NDK = "${androidSdk}/libexec/android-sdk/ndk/21.1.6352462";
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/30.0.3/aapt2";
  };

  meta = {
    description = "PATrace is software for capturing GLES calls of an application and replaying them on a different device, keeping the GPU workload the same. It's similar to the open source Apitrace project, but optimised for performance measurements.";
    homepage = "github.com/ARM-software/patrace";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
