#include "opencvbackend.h"
#include <QQmlEngine>
#include "pixmapcontainer.h"

#include <QTimer>

#include <iostream>
#include <stdio.h>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/objdetect.hpp>

#include <QDebug>

using namespace std;

OpenCvBackend::OpenCvBackend()
{  
}

OpenCvBackend::~OpenCvBackend()
{
//    delete full_body_cascade;
//    delete lower_body_cascade;
}

QImage OpenCvBackend::processRGB(int index, Mat &inputMat) {
    _frameOriginal[index] = inputMat;
    cvtColor(_frameOriginal[index], _frameProcessed[index], COLOR_BGR2RGB); //regular color
    return QImage((const unsigned char *)_frameProcessed[index].data, _frameProcessed[index].cols, _frameProcessed[index].rows, QImage::Format_RGB888);
}

QImage OpenCvBackend::processGray(int index, Mat &inputMat) {
    _frameOriginal[index] = inputMat;
    _frameProcessed[index];
    cvtColor(_frameOriginal[index], _frameProcessed[index], COLOR_BGR2GRAY);
    return QImage((const unsigned char *)_frameProcessed[index].data, _frameProcessed[index].cols, _frameProcessed[index].rows, QImage::Format_Indexed8);
}

QImage OpenCvBackend::processBinaryThreshold(int index, Mat &inputMat) {
    _frameOriginal[index] = inputMat;
    _frameProcessed[index];
    cvtColor(_frameOriginal[index], _frameProcessed[index], COLOR_BGR2GRAY);
    //apply a fixed filter to demonstrate success
    threshold(_frameProcessed[index], _frameProcessed[index], 100, 255, THRESH_BINARY);
    return QImage((const unsigned char *)_frameProcessed[index].data, _frameProcessed[index].cols, _frameProcessed[index].rows, QImage::Format_Indexed8);
}

QImage OpenCvBackend::houghLineDetection(int index, Mat &inputMat) {

    _frameOriginal[index] = inputMat;

    Mat gray;
    cvtColor(_frameOriginal[index], gray, COLOR_BGR2GRAY); //gray

    Mat canny;
    Canny(gray, canny, 50, 200, 3);

    vector<Vec4i> lines;
    HoughLinesP(canny, lines, 1, CV_PI/180, 50, 50, 10 );

    for (size_t i = 0; i < lines.size(); i++ )
    {
        Vec4i l = lines[i];
        line( _frameOriginal[index], Point(l[0], l[1]), Point(l[2], l[3]), Scalar(0,0,255), 3, CV_AA);
    }

    _frameProcessed[index] = _frameOriginal[index];


    cvtColor(_frameProcessed[index], _frameProcessed[index], COLOR_BGR2RGB); //regular color

    inputMat = _frameProcessed[index];
    return QImage((const unsigned char *)_frameProcessed[index].data, _frameProcessed[index].cols, _frameProcessed[index].rows, QImage::Format_RGB888);
}













