import QtQuick 2.0
import QtQuick.Controls 2.1

// this class is for a control button

Rectangle {
    property string buttonName;
    property var inputCameraName;
    property string buttonMouseArea;
//    property var isPaused: isPaused;
    id: _rectangeLabel
    width: 80
    height: 30
    color: "lightgray"
    Label {
        anchors.centerIn: parent;
        color: "black"
        text: buttonName
    }
    MouseArea {
        id: buttonMouseArea
        hoverEnabled: true;
        anchors.fill: parent;
        onEntered: parent.color = "lightblue"
        onExited: parent.color = "lightyellow"

        onClicked: {
            if (typeof inputCameraName !== "undefined") console.log(buttonName + " clicked from " + inputCameraName);
            else console.log(buttonName + " clicked");
            action();
        }
    }
}
