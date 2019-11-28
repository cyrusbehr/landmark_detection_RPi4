# Cross Compiling Landmark Detection Program for ARM32 / ARM64

For step by step explanation, please refer to [this article]()

## Build Steps

### AArch32
* Navigate to the `3rd_party_libs` directory and run the following:
    * `./build_ncnn.sh`
    * `./build_opencv.sh`

### AArch64
* Navigate to the `3rd_party_libs` directory and run the following:
    * `./build_ncnn.sh -b aarch64`
    * `./build_opencv.sh -b aarch64`
