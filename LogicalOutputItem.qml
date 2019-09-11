import QtQuick 2.0

LogicalBaseItem
{
    id: container

    logicalType: 2
    name: "Output"
    color: isOn ? "#ffe386" : "white"
    property bool isOn: false

    property var inPinPos: [{"x": x, "y": y + height / 2}]
    property var pinConnect: [inPin.pinConnect]

    Text
    {
        text: "Output"
        font.pixelSize: 18
        anchors.centerIn: parent
    }

    InPinItem
    {
        id: inPin

        x: - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
        pinNumber: 0
    }
}
