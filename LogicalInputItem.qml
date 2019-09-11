import QtQuick 2.0

LogicalBaseItem
{
    id: container

    color: isOn ? "#ffe386" : "white"

    imgPath: ""
    logicalType: 1

    property var outPinPos: {"x": x + width, "y": y + height / 2}
    property bool isOn: false

    OutPinItem
    {
        id: outPin

        x: logicalItemSize - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
    }

    Rectangle
    {
        width: logicalItemSize * 0.6
        height: logicalItemSize * 0.8
        x: (logicalItemSize - width) / 2
        y: logicalItemSize - height

        border
        {
            width: 2
            color: "black"
        }

        Text
        {
            text: "On/Off"
            font.pixelSize: 18
            anchors.centerIn: parent
        }

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                isOn = !isOn
                canvas.sendConnections()
            }
        }
    }

    DestroyItem
    {
        father: container
    }
}
