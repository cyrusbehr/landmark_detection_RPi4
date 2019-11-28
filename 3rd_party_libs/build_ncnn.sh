build_type="aarch32"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$0 - download and build ncnn"
      echo " "
      echo "$0 [options] [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-b, --build type          specify a modified build type (aarch32, aarch64, default: aarch32)"
      exit 0
      ;;
    -b|--build)
      shift
      if test $# -gt 0; then
        if [ "$1" = "aarch32" ]; then
          build_type="aarch32"
        elif [ "$1" = "aarch64" ]; then
          build_type="aarch64"
        else
          echo "unsupported build type: $1"
          exit 1
        fi
      else
        echo "no build type specified"
        exit 1
      fi
      shift
      ;;
    *)
      echo "unsupported option: $1"
      exit 1
      ;;
  esac
done

# download ncnn
test -e ncnn || git clone git@github.com:Tencent/ncnn.git

cd ncnn

if [ "$build_type" = "aarch32" ]; then
  #########
  # build for aarch32 architecture
  #########
  echo "Building ncnn for AArch32"

  mkdir build_aarch32
  cd build_aarch32

  cmake -D NCNN_BUILD_TOOLS=OFF -D NCNN_VULKAN=OFF -D CMAKE_BUILD_TYPE=Release -D NCNN_DISABLE_RTTI=OFF -D CMAKE_TOOLCHAIN_FILE=../toolchains/arm-linux-gnueabihf.toolchain.cmake ..


  make -j$(nproc)
  make install

  elif [ "$build_type" = "aarch64" ]; then
  #########
  # build for arm architecture
  #########

  echo "Building ncnn for AArch64"
  mkdir build_aarch64
  cd build_aarch64

  cmake -D NCNN_BUILD_TOOLS=OFF -D NCNN_VULKAN=OFF -D CMAKE_BUILD_TYPE=Release -D NCNN_DISABLE_RTTI=OFF -D CMAKE_TOOLCHAIN_FILE=../toolchains/aarch64-linux-gnu.toolchain.cmake ..

  make -j$(nproc)
  make install

else
  echo "unsupported build type: $build_type"
  exit 1
fi;