{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:
stdenv.mkDerivation rec {
  pname = "applesmc-next";
  version = "0.1.5";
  name = "${pname}-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "c---";
    repo = "applesmc-next";
    rev = version;
    hash = "sha256-Kh34suuoCLSBZH64EzqgIMJHjRVowmL94MEhHgx4GNg=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      -j$NIX_BUILD_CORES M=$(pwd) modules $makeFlags
  '';

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build  \
      INSTALL_MOD_PATH=$out M=$(pwd) modules_install $makeFlags
  '';

  meta = {
    description = "Apple SMC Next DKMS driver";
    longDescription = ''
      The Apple SMC Next DKMS driver. Allows setting battery charge thresholds on Intel Apple devices.
    '';
    homepage = "https://github.com/c---/applesmc-next";
    license = lib.licenses.gpl2Only;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = [ lib.maintainers.tmmy ];
  };
}
