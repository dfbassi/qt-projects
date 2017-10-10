import QtQuick 2.6
import QtQuick.Window 2.2

import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import io.qt.forum 1.0
import QtQuick.Dialogs 1.0


ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1200
    height: 800
    title: qsTr("Vision Platform GUI")

    header: ControlToolBar {
        id: _controlToolBar
        // this is important for all recording toggling
        recording_indices: [cameraTile_0, cameraTile_1, cameraTile_2, cameraTile_3, cameraTile_4,
            cameraTile_5]
    }

    GridLayout {
        id: grid
        width: 1242
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 20
        anchors.topMargin: 0
        columns: 3
        rowSpacing: 6
        columnSpacing: 6
        anchors.fill: parent

        CameraTile {
            id: cameraTile_0
            indexNum: 0
            cameraName: "0"
            isCamera: true;
            width: 200; height: 200
            updateRate: 30;
        }

        CameraTile {
            id: cameraTile_1
            indexNum: 1
            cameraName: "/home/danilo/Desktop/cart_videos/video_FR.h264";
            isVideo: true;
            width: 200; height: 200
            updateRate: 30
        }

        CameraTile {
            id: cameraTile_2
            indexNum: 2
            cameraName: "~/danilo-video/ch01_20170104101859.mp4";
            isVideo: true;
            width: 200; height: 200
            updateRate: 30
        }
        CameraTile {
            id: cameraTile_3
            indexNum: 3
            cameraName: "~/Desktop/cart_videos/video_LE.h264";
            isVideo: true;
            width: 200; height: 200
            updateRate: 30
        }
        CameraTile {
            id: cameraTile_4
            indexNum: 4
            cameraName: "~/Desktop/cart_videos/video_RE.h264";
            isVideo: true;
            width: 200; height: 200
            updateRate: 30
        }
        CameraTile {
            id: cameraTile_5
            indexNum: 5
            cameraName: "~/Desktop/cart_videos/video_RI.h264";
            isCamera: true;
            width: 200; height: 200
            updateRate: 30
        }
    }
}


