#include "opencvhandler.h"
#include "opencvbackend.h"

#include <opencv2/imgproc/imgproc.hpp>
#include <QQmlEngine>

#include <iostream>

#include <QDebug>

#include "pixmapcontainer.h"

OpenCvHandler::OpenCvHandler(QObject *parent) : QObject(parent)
{
    backendProcessor = new OpenCvBackend();
    namingIndex = 0; //set namingIndex to make sure we don't overwrite recordings
}

OpenCvHandler::~OpenCvHandler()
{
    for (int i = 0; i < 10; i++){
        if(cap[i]->isOpened()) cap[i]->release();
        delete cap[i];
        if(video_writer[i]->isOpened()) video_writer[i]->release();
        delete video_writer[i];
    }
}

void OpenCvHandler::setup(int index, QString cameraString, bool camera, bool image, bool video){
    qDebug() << "camera name " << cameraString;

    // start assuming its not an image or video
    isImage[index] = false;
    isVideo[index] = false;
    frameNumberLimit[index] = 0; // default to 0
    currentFrameNumber[index] = -1; // start all frames at the beginning

    isVideoComplete[index] = false;

    if (camera) {
        cap[index] = new VideoCapture();
        cap[index]->open(cameraString.toInt());
    }
    // check if this is an image
    else if (image){
        isImage[index] = true;
        qDebug() << "image";
    }
    // assume this is a video
    else if (video) {
        isVideo[index] = true;
        qDebug() << "video";
        cap[index] = new VideoCapture();
        cap[index]->open(cameraString.toStdString());
        frameNumberLimit[index] = cap[index]->get(CV_CAP_PROP_FRAME_COUNT);
        cap[index]->set(CV_CAP_PROP_POS_FRAMES, 0.0);
        qDebug() << "max number of frames " << frameNumberLimit[index];
    }

}

void OpenCvHandler::startRecording(int index, QString cameraString) {
    std::string camera_std_string = cameraString.toStdString();
    video_writer[index] = new VideoWriter();
    int width = cap[index]->get(CV_CAP_PROP_FRAME_WIDTH);
    int height = cap[index]->get(CV_CAP_PROP_FRAME_HEIGHT);
    video_writer[index]->open(camera_std_string + "_" + std::to_string(namingIndex) + ".avi", CV_FOURCC('M','J','P','G'), 30, Size(width,height), true);
    namingIndex += 1;
}

void OpenCvHandler::restartVideo(int index) {
    currentFrameNumber[index] = -1.0;
}

void OpenCvHandler::endOfVideo(int index) {
    currentFrameNumber[index] = frameNumberLimit[index] - 1.0;
}

bool OpenCvHandler::videoEndedChecker(int index) {
    return isVideoComplete[index];
}

//currently this records only the original camera reading
QObject *OpenCvHandler::grabFrame(int index, QString cameraString, bool isRecording, bool isBackward, bool isPaused)
{
    //get a QImage from the opencv class

    if (isImage[index]) {
        std::string camera_std_string = cameraString.toStdString();
        _currentFrame[index] = imread(camera_std_string);
    }

    else if (isVideo[index]) {

        //this block here is for video controls
        if (isBackward && currentFrameNumber[index] > -1) {
            m_videoEnded = false;
            isVideoComplete[index] = false;
            currentFrameNumber[index] -= 1.0;
        }
        else if (currentFrameNumber[index] < frameNumberLimit[index] - 1){
            m_videoEnded = false;
            isVideoComplete[index] = false;
            currentFrameNumber[index] += 1.0;
        }
        else if (currentFrameNumber[index] == frameNumberLimit[index] - 1) {
            m_videoEnded = true;
            isVideoComplete[index] = true;
            return new PixmapContainer(); //Ethan needs to change, but this was the quickest solution for short term. Talk to Edgar
        }
//        if (!isPaused) emit videoEndedChanged();
        if (isPaused || currentFrameNumber[index] == frameNumberLimit[index] - 1) cap[index]->set(CV_CAP_PROP_POS_FRAMES, currentFrameNumber[index]);

        // grab the correct frame
        (*cap[index]) >> _currentFrame[index];

//        This line prints the percent of the video
//        qDebug() << "Percent of video: " << currentFrameNumber[index] / frameNumberLimit[index] * 100.0;
    }

    // if it's not an image
    else {
        (*cap[index]) >> _currentFrame[index];
        if (_currentFrame[index].empty()){
            // this will prevent a potentially infinite while loop
            return new PixmapContainer();
        }
    }

    if (isRecording) {
        video_writer[index]->write(_currentFrame[index]);
    }

    output[index] = backendProcessor->processRGB(index, _currentFrame[index]);

// this handles the return process to set the pixmap
    PixmapContainer * pc = new PixmapContainer();
    pc->pixmap = QPixmap::fromImage(output[index]);
    Q_ASSERT(!pc->pixmap.isNull());
    QQmlEngine::setObjectOwnership(pc, QQmlEngine::JavaScriptOwnership);
    return pc;
}


