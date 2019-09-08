import QtQuick 2.0

LogicalBaseItem
{
    id: container

    imgPath: "qrc:/images/LogicalItems/logicalOutput.png"
    logicalType: 2
    name: "Output"

    property var inPinPos: [{"x": x, "y": y + height / 2}]
    property var pinConnect: [inPin.pinConnect]

    InPinItem
    {
        id: inPin

        x: - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
        pinNumber: 0
    }
}
