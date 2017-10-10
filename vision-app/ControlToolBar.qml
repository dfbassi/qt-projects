import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

ToolBar {
    property var recording_indices: []
    RowLayout {
        anchors.fill: parent
        ControlButton {
            buttonName: "RECORD ALL"
            height: parent.height * .9; width: parent.width * .3;
            function action() {
                if (buttonName == "RECORD ALL") {
                    for (var i = 0; i < recording_indices.length; i++) {
                        recording_indices[i].startRecord();
                    }
                    buttonName = "STOP ALL";
                } else {
                    for (var i = 0; i < recording_indices.length; i++) {
                        recording_indices[i].stopRecord();
                    }
                    buttonName = "RECORD ALL";
                }
            }
        }
        ControlButton {
            buttonName: "PAUSE ALL"
            height: parent.height * .9; width: parent.width * .3;
            function action() {
                if (buttonName == "PLAY ALL") {
                    for (var i = 0; i < recording_indices.length; i++) {
                        recording_indices[i].play();
                    }
                    buttonName = "PAUSE ALL";
                } else {
                    for (var i = 0; i < recording_indices.length; i++) {
                        recording_indices[i].pause();
                    }
                    buttonName = "PLAY ALL";
                }
            }
        }
        Item { Layout.fillWidth: true }
    }
}
