import QtQuick 2.9
import "qml/"

Rectangle {
    id: window
    width: 1024
    height: 694
    color: "black"

    EffectView {
        anchors.fill: parent

        model: [
            { name: "Test_A", effectSource: "qrc:/Image/ImageView/Test_A.png", codeSource: Qt.resolvedUrl("qml/TestEffect_A.qml") },
            { name: "Test_B", effectSource: "qrc:/Image/ImageView/Test_B.png", codeSource: Qt.resolvedUrl("qml/TestEffect_B.qml") },
            { name: "Test_C", effectSource: "qrc:/Image/ImageView/Test_C.png", codeSource: Qt.resolvedUrl("qml/TestEffect_C.qml") },
            { name: "Test_D", effectSource: "qrc:/Image/ImageView/Test_D.png", codeSource: Qt.resolvedUrl("qml/TestEffect_D.qml") },
            { name: "Test_E", effectSource: "qrc:/Image/ImageView/Test_E.png", codeSource: Qt.resolvedUrl("qml/TestEffect_E.qml") },
            { name: "Test_F", effectSource: "qrc:/Image/ImageView/Test_F.png", codeSource: Qt.resolvedUrl("qml/TestEffect_F.qml") },
            { name: "Test_G", effectSource: "qrc:/Image/ImageView/Test_G.png", codeSource: Qt.resolvedUrl("qml/TestEffect_G.qml") },
            { name: "Test_H", effectSource: "qrc:/Image/ImageView/Test_H.png", codeSource: Qt.resolvedUrl("qml/TestEffect_H.qml") }
        ]
    }
}
