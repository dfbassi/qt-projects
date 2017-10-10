import QtQuick 2.0

Rectangle {
     width: parent.width * .05
     height: width
     visible: false
     color: "red"
     border.color: "black"
     border.width: 1
     radius: width*0.5
     anchors.top: parent.top
     anchors.right: parent.right
     anchors.margins: 3


//     this could later be used to show the time on the recording
//     Text {
//          anchors.centerIn: parent
//          text: "1"
//     }
}
