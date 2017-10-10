import QtQuick 2.0

Rectangle {
    height: parent.height * .1
    width: height * 4
    visible: false
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 3

    Row {
        spacing: 1
        anchors.fill: parent

        ControlButton {
            id: beginningFrame
            buttonName: "<<"
            inputCameraName: cameraName;
            height: parent.height; width: parent.width * .25;
//            anchors.left: parent.left;
            function action() {
                opencv_handler.restartVideo(indexNum);
                capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, isRecording, false, true) );
            }
        }

        ControlButton {
            id: backFrame
            buttonName: "<"
            inputCameraName: cameraName;
            height: parent.height; width: parent.width * .25;
//            anchors.left: beginningFrame.right;
            function action() {
                capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, isRecording, true, true) );
            }
        }

        ControlButton {
            id: forwardFrame
            buttonName: ">"
            inputCameraName: cameraName;
            height: parent.height; width: parent.width * .25;
//            anchors.left: backFrame.right;
//            anchors.right: lastFrame.left;
            function action() {
                capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, isRecording, false, true) );
            }
        }

        ControlButton {
            id: lastFrame
            buttonName: ">>"
            inputCameraName: cameraName;
            height: parent.height; width: parent.width * .25;
//            anchors.right: parent.right;
            function action() {
                opencv_handler.endOfVideo(indexNum);
                capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, isRecording, false, true) );
            }
        }
    }
}
