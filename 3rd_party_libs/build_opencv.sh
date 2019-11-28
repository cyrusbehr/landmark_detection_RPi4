build_type="aarch32"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$0 - download and build opencv"
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

# download opencv 4.1.1
test -e opencv.zip || wget -O opencv.zip https://github.com/opencv/opencv/archive/4.1.1.zip
test -e opencv-4.1.1 || unzip opencv

mv opencv-4.1.1 opencv

cd opencv

if [ "$build_type" = "aarch32" ]; then
  #########
  # build for aarch32 architecture
  #########
  echo "Building ncnn for AArch32"

  mkdir build_aarch32
  cd build_aarch32

  cmake -DCMAKE_TOOLCHAIN_FILE="../platforms/linux/arm-gnueabi.toolchain.cmake" -D CMAKE_INSTALL_PREFIX="/usr/local" -D BUILD_SHARED_LIBS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_DOCS=OFF -D BUILD_EXAMPLES=OFF -D BUILD_opencv_apps=OFF -D WITH_CAROTENE=OFF -D BUILD_opencv_python2=OFF -D BUILD_opencv_python3=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D FORCE_VTK=OFF -D WITH_FFMPEG=OFF -D WITH_GDAL=OFF -D WITH_IPP=OFF -D WITH_OPENEXR=OFF -D WITH_OPENGL=OFF -D WITH_QT=OFF -D WITH_TBB=OFF -D WITH_XINE=OFF -D BUILD_JPEG=ON -D BUILD_ZLIB=ON -D BUILD_PNG=ON -D BUILD_TIFF=OFF -D BUILD_BUILD_JASPER=OFF -D WITH_ITT=OFF -D WITH_LAPACK=OFF -D WITH_OPENCL=OFF -D WITH_TIFF=OFF -D WITH_PNG=ON -D WITH_OPENCLAMDFFT=OFF -D WITH_OPENCLAMDBLAS=OFF -D WITH_VA_INTEL=OFF -D WITH_WEBP=OFF -D WITH_JASPER=OFF ..

  make -j$(nproc)

  mkdir install_aarch32
  make DESTDIR=./install_aarch32 install

  elif [ "$build_type" = "aarch64" ]; then
  #########
  # build for arm architecture
  #########

  mkdir build_aarch64
  cd build_aarch64

  cmake -DCMAKE_TOOLCHAIN_FILE="../platforms/linux/aarch64-gnu.toolchain.cmake" -D CMAKE_INSTALL_PREFIX="/usr/local" -D BUILD_SHARED_LIBS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_DOCS=OFF -D BUILD_EXAMPLES=OFF -D BUILD_opencv_apps=OFF -D WITH_CAROTENE=OFF -D BUILD_opencv_python2=OFF -D BUILD_opencv_python3=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D FORCE_VTK=OFF -D WITH_FFMPEG=OFF -D WITH_GDAL=OFF -D WITH_IPP=OFF -D WITH_OPENEXR=OFF -D WITH_OPENGL=OFF -D WITH_QT=OFF -D WITH_TBB=OFF -D WITH_XINE=OFF -D BUILD_JPEG=ON -D BUILD_ZLIB=ON -D BUILD_PNG=ON -D BUILD_TIFF=OFF -D BUILD_BUILD_JASPER=OFF -D WITH_ITT=OFF -D WITH_LAPACK=OFF -D WITH_OPENCL=OFF -D WITH_TIFF=OFF -D WITH_PNG=ON -D WITH_OPENCLAMDFFT=OFF -D WITH_OPENCLAMDBLAS=OFF -D WITH_VA_INTEL=OFF -D WITH_WEBP=OFF -D WITH_JASPER=OFF ..

  make -j$(nproc)

  mkdir install_aarch64
  make DESTDIR=./install_aarch64 install

else
  echo "unsupported build type: $build_type"
  exit 1
fi;