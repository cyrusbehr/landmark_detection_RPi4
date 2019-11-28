#include <opencv2/opencv.hpp>
#include <memory>
#include <string>
#include <vector>

#include "mtcnn.h"
#include "net.h"

// Loads image, computes landmark locations, draws landmarks on image and save to disk
void detectLandmarks(const std::string& imgPath, const std::unique_ptr<MTCNN>& mtcnnPtr);

int main(int argc, char **argv) {
    if (argc <= 1) {
        std::cout << "Error: no image path provided\n";
        return -1;
    }

    const std::string MODEL_DIRECTORY = "../models";
    auto mtcnnPtr = std::make_unique<MTCNN>(MODEL_DIRECTORY);

    for (int i = 1; i < argc; ++i) {
        detectLandmarks(argv[i], mtcnnPtr);
    }
}

void detectLandmarks(const std::string& imgPath, const std::unique_ptr<MTCNN>& mtcnnPtr) {
    auto img = cv::imread(imgPath);

    if (!img.data) {
        std::cout << "Unable to open image at path " << imgPath << std::endl;
        return;
    }

    // OpenCV loads as BGR, mtcnn models expect RGB
    auto ncnnImg = ncnn::Mat::from_pixels(img.data, ncnn::Mat::PIXEL_BGR2RGB, img.cols, img.rows);
    std::vector<Bbox> bboxVec;

    mtcnnPtr->detect(ncnnImg, bboxVec);
    if (bboxVec.empty()) {
        std::cout << "Unable to detect face in image" << std::endl;
        return;
    }

    for (auto & bbox : bboxVec) {
        cv::Point topLeft(bbox.x1, bbox.y1);
        cv::Point bottomRight(bbox.x2, bbox.y2);
        cv::rectangle(img, topLeft, bottomRight, cv::Scalar(255, 0, 0), 2);

        for (int j = 0; j < 5; ++j) {
            cv::Point p(bbox.landmark.x[j], bbox.landmark.y[j]);
            cv::circle(img, p, 1, cv::Scalar(0, 255, 0), 3, cv::LINE_AA);
        }
    }

    // Save the image to disk
    auto imgName = imgPath.substr(imgPath.find_last_of('/') + 1, imgPath.find_last_of('.') - imgPath.find_last_of('/') - 1);
    auto imgSuffix = imgPath.substr(imgPath.find_last_of('.'));

    auto outputName = imgName + "_landmarks" + imgSuffix;
    cv::imwrite(outputName, img);
}

