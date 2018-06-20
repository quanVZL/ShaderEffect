import QtQuick 2.8
import QtQuick.Controls 2.2

Item {
    property string key: ""
    property real mix: 0.0
    property real max: 1.0
    property alias value: rootSlider.value
    height: title.height

    Text {
        id: title
        text: key
        color: "white"
        font.pixelSize: 25
    }

    Slider {
        id: rootSlider
        anchors.left: title.right
        anchors.leftMargin: 10
        from: mix
        to: max
        value: 1.0
    }

    Text {
        id: sliderValue
        anchors.left: rootSlider.right
        anchors.leftMargin: 10
        text: rootSlider.value.toFixed(4)
        color: "white"
        font.pixelSize: 25
    }
}
