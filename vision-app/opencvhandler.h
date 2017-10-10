#ifndef OPENCVHANDLER_H
#define OPENCVHANDLER_H

#include <QObject>
#include <QString>
#include <QImage>

#include "opencvbackend.h"

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;

class OpenCvHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool videoEnded READ videoEnded NOTIFY videoEndedChanged)

private:
    OpenCvBackend *backendProcessor;
    VideoCapture *cap[10];
    VideoWriter *video_writer[10];

    bool isImage[10];

    bool isVideo[10];
    int frameNumberLimit[10];
    double currentFrameNumber[10];

    int namingIndex;

    Mat _currentFrame[10];

    bool isVideoComplete[10];
    bool m_videoEnded;

    QImage output[10];

public:
    explicit OpenCvHandler(QObject *parent = nullptr);
    ~OpenCvHandler();

    Q_INVOKABLE void setup(int index, QString cameraString, bool camera, bool image, bool video);

    Q_INVOKABLE bool videoEndedChecker(int index);

    Q_INVOKABLE void restartVideo(int index);
    Q_INVOKABLE void endOfVideo(int index);

    Q_INVOKABLE void startRecording(int index, QString cameraString);

    Q_INVOKABLE QObject* grabFrame(int index, QString cameraString, bool isRecording, bool isBackward, bool isPaused);

    bool videoEnded() const {
        return m_videoEnded;
    }

signals:
    void videoEndedChanged();
    void updateEndFrame();

public slots:
};

#endif // OPENCVHANDLER_H
