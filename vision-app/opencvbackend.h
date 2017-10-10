#ifndef OPENCVBACKEND_H
#define OPENCVBACKEND_H

#include <QImage>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/objdetect.hpp>

using namespace cv;

class OpenCvBackend
{

private:
    Mat _frameOriginal[10];
    Mat _frameProcessed[10];

public:
    explicit OpenCvBackend();
    ~OpenCvBackend(); //this is the destructor

    //process functions responsible for the processing of applying filters, etc.
    QImage processRGB(int index, Mat &input_mat);
    QImage processGray(int index, Mat &input_mat);
    QImage processBinaryThreshold(int index, Mat &inputMat);
    QImage houghLineDetection(int index, Mat &inputMat);

};

#endif // OPENCVBACKEND_H
