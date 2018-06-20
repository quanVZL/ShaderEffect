import QtQuick 2.10
import QtQuick.Controls 2.4

Rectangle {
    id: rootPage
    color: "transparent"

    property alias codeSource: loader.source
    property alias nameSource: titleText.text

    Loader {
        id: loader
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
    }

    Rectangle {
        id: header
        width: parent.width
        height: titleText.contentHeight * 2
        color: "black"

        Button {
            id: choose
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5

            text: qsTr("退出")

            onClicked: {
                rootPage.parent.pop();
            }

            background: Rectangle {
                implicitWidth: 30
                implicitHeight: 20
                radius: 4
                color: choose.pressed ? "gray" : "white"
                border.width: 1
                border.color: "#f1a4a4"
            }
        }

        Text {
            id: titleText
            anchors.centerIn: parent
            text: nameSource
            color: "white"
            font.pixelSize: 20
            font.italic: true
        }
    }
}
