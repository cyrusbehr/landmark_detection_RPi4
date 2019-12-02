# Cross Compiling Landmark Detection Program for ARM32 / ARM64

For step by step explanation, please refer to [this article]()

![](https://cdn-images-1.medium.com/max/800/1*_cw6U2HGKpegUW9uPjnfXQ.gif)

![](https://cdn-images-1.medium.com/max/800/1*uUCO35XLs7z--iF9CMXmaw.jpeg)

## Build Steps

### AArch32
* Navigate to the `3rd_party_libs` directory and run the following:
    * `./build_ncnn.sh`
    * `./build_opencv.sh`
* Navigate back to the root directory
    * `mv CMakeLists.txt.aarch32 CMakeLists.txt`
    * `mkdir build_aarch32`
    * `cd build_aarch32`
    * `cmake ..`
    * `make -j$(nproc)`

### AArch64
* Navigate to the `3rd_party_libs` directory and run the following:
    * `./build_ncnn.sh -b aarch64`
    * `./build_opencv.sh -b aarch64`
* Navigate back to the root directory
    * `mv CMakeLists.txt.aarch64 CMakeLists.txt`
    * `mkdir build_aarch64`
    * `cd build_aarch64`
    * `cmake ..`
    * `make -j$(nproc)`