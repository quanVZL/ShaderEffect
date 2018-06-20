import QtQuick.Controls 2.4
import QtQuick 2.10

StackView {
    id: rootStackView

    property alias model: rootView.model

    initialItem: ListView {
        id: rootView
        width: rootStackView.width
        height: rootStackView.height

        delegate: Rectangle {
            id: rect
            property bool bingo: false

            width: rootStackView.width
            height: 200 + 100 * bingo
            border.color: "aqua"
            border.width: 1

            Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }

            Row {
                anchors.fill: parent
                spacing: 3

                Image {
                    width: rect.height * 16/9
                    height: rect.height

                    source: rootView.model[index].effectSource
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            rect.bingo = !rect.bingo
                        }
                    }
                }

                Button {
                    id: choose
                    text: qsTr("预览")

                    onClicked: {
                        rootStackView.push(pageCommon, {"nameSource": rootView.model[index].name,
                                               "codeSource": rootView.model[index].codeSource})
                    }

                    background: Rectangle {
                        implicitWidth: 30
                        implicitHeight: 20
                        radius: 4
                        color: choose.pressed ? "#f4bebe" : "white"
                        border.width: 1
                        border.color: "#e7e7e7"
                    }
                }
            }
        }
    }

    Component {
        id: pageCommon
        CommonPage {
            width: rootStackView.width
            height: rootStackView.height
        }
    }
}


