import QtQuick 2.0

LogicalBaseItem
{
    id: container

    imgPath: "qrc:/images/LogicalItems/logicalNot.png"
    logicalType: 2
    name: "Not"

    property var inPinPos: [{"x": x, "y": y + height / 2}]
    property var outPinPos: {"x": x + width, "y": y + height / 2}
    property var pinConnect: [inPin.pinConnect]


    InPinItem
    {
        id: inPin

        x: - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
        pinNumber: 0
    }

    OutPinItem
    {
        id: outPin

        x: logicalItemSize - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
    }

    DestroyItem
    {
        father: container
    }
}
