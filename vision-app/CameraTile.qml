import QtQuick 2.0

import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import io.qt.forum 1.0
import QtQuick 2.7
import QtQuick.Dialogs 1.0

Rectangle {

    property var cameraName;
    property int updateRate;
    property bool menuState: false;
    property int indexNum;
    property bool isPaused: false;
    property bool isRecording: false;


    property bool isCamera: false;
    property bool isImage: false;
    property bool isVideo: false;

    property bool videoEnded: opencv_handler.videoEnded

//    onVideoEndedChanged: {
//        console.log("test video complete");
//        var videoCompleted = opencv_handler.videoEndedChecker(indexNum);
//        console.log(videoCompleted);
//        if (videoCompleted) pause();
//        else play();
//    }

//    id: _cameraWindow
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#33f0ff"

    Label {
        anchors.centerIn: parent
        text: "Input: " + cameraName
        color: "black"
    }
    PixmapImage {
        id: capPixmapImage
        anchors.fill: parent
    }
    Timer {
        id: timer
        interval: updateRate
        repeat: true
        triggeredOnStart: false
        running: true
        onTriggered: {
            if (!isImage) {
                if (!isPaused) capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, isRecording, false, false) );
            }
        }
    }

    RecordingDot {
        id: recordingDot
    }

    FrameChangeGroup {
        id: frameChangeGroup
        z: 1
    }

    Rectangle {
        id: menu
        height: parent.height
        width: parent.width * .3
        color: "orange"
        visible: false;
        z: 1
        Column {
            spacing: 5
            anchors.fill: parent

            // PLAY & PAUSE button
            ControlButton {
                id: playPauseButton
                buttonName: "PAUSE"
                inputCameraName: cameraName;
                height: parent.height * .25; width: parent.width;
                function action() {
                    if (isPaused) {
                        play();
                    }
                    else {
                        pause();
                    }
                }
            }

            // RECORD & STOP button
            ControlButton {
                id: recordButton
                buttonName: "RECORD"
                inputCameraName: cameraName;
                height: parent.height * .25; width: parent.width;
                function action() {
                    if (buttonName == "RECORD") {
                        startRecord();
                    } else {
                        stopRecord();
                    }
                }
            }

            // LOAD INPUT button
            ControlButton {
                id: loadButton
                buttonName: "LOAD INPUT"
                inputCameraName: cameraName;
                height: parent.height * .25; width: parent.width;
                function action() {
                    popup.open();
                    pause();
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            var url_string = "" + fileDialog.fileUrls;
            var len_val = url_string.length;
            console.log(len_val);
            var file_string = url_string.slice(7, len_val);
            console.log("You chose: " + file_string);

            cameraName = file_string;

            opencv_handler.setup(indexNum, cameraName, isCamera, isImage, isVideo);

            if (isImage) capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, false, false, false) );

            play();
        }
        onRejected: {
            console.log("Canceled")
            frameChangeGroup.visible = false;
        }
        Component.onCompleted: visible = false
    }

    Rectangle {

        anchors.centerIn: parent
        width: parent.width * .5
        height: parent.height * .5
        visible: false

        Popup {
            id: popup
            modal: true
            focus: true
            x: 0
            y: 0
            width: parent.width
            height: parent.height
//            padding: real
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            onOpened: {
                parent.visible = true;
            }

            onClosed: {
                parent.visible = false;
            }

            ColumnLayout {
                anchors.centerIn: parent
                Button {
                    text: qsTr("Image")
                    onClicked:{
                        isCamera = false;
                        isImage = true;
                        isVideo = false;
                        popup.close();
                        fileDialog.visible = true;
                    }
                }
                Button {
                    text: qsTr("Video")
                    onClicked:{
                        isCamera = false;
                        isImage = false;
                        isVideo = true;
                        popup.close();
                        fileDialog.visible = true;
                    }
                }
            }
        }
    }

    MouseArea {
        id: capMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            console.log("Clicked " + cameraName);
            if (!menuState) {
                menu.visible = true;
            } else {
                menu.visible = false;
            }
            menuState = !menuState;
        }
        onEntered: capPixmapImage.opacity = .6
        onExited:  capPixmapImage.opacity = 1
    }

    Component.onCompleted: {
        opencv_handler.setup(indexNum, cameraName, isCamera, isImage, isVideo);
        if (isImage) {
             capPixmapImage.setImage( opencv_handler.grabFrame(indexNum, cameraName, false, false, false) );
        } else {
            timer.start();
        }
    }

    function pause() {
        isPaused = true;
        playPauseButton.buttonName = "PLAY";
        frameChangeGroup.visible = true;
    }

    function play() {
        isPaused = false;
        playPauseButton.buttonName = "PAUSE";
        frameChangeGroup.visible = false;
    }

    function startRecord() {
        recordingDot.visible = true;
        opencv_handler.startRecording(indexNum, cameraName)
        isRecording = true;
        recordButton.buttonName = "STOP";
    }

    function stopRecord() {
        recordingDot.visible = false;
        isRecording = false;
        recordButton.buttonName = "RECORD";
    }
}
