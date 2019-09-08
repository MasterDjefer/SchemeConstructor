import QtQuick 2.0

LogicalBaseItem
{
    id: container

    logicalType: 3

    property var inPinPos: [null, {"x": x, "y": y + height / 3}, {"x": x, "y": y + height / 3 * 2}]
    property var outPinPos: {"x": x + width, "y": y + height / 2}
    property var pinConnect: [null, inPin1.pinConnect, inPin2.pinConnect]


    InPinItem
    {
        id: inPin1

        x: - pinSize / 2
        y: logicalItemSize / 3 - pinSize / 2
        father: container
        pinNumber: 1
    }

    InPinItem
    {
        id: inPin2

        x: - pinSize / 2
        y: logicalItemSize / 3 * 2 - pinSize / 2
        father: container
        pinNumber: 2
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
