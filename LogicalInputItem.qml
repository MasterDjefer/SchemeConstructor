import QtQuick 2.0

LogicalBaseItem
{
    id: container

    color: isOn ? "yellow" : "white"

    imgPath: ""
    type: 1

    property var outPinPos: {"x": x + width, "y": y + height / 2}
    property bool isOn: false

    PinItem
    {
        id: outPin

        x: logicalItemSize - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
        type: "out"

        onPressedFunc: function()
        {
            isConnectable = true
            canvas.setActiveItem(container, pinArea)
        }

        onReleasedFunc: function()
        {
            for (var i = 0; i < mainWindow.logicalItems.length; ++i)
            {
                var logicalItem = mainWindow.logicalItems[i]
                if (container === logicalItem)
                {
                    continue
                }

                var endLinePos = {"x": outPinPos.x + pinArea.mouseX, "y": outPinPos.y + pinArea.mouseY}

                if (logicalItem.type === 2)
                {
                    if (endLinePos.x >= logicalItem.inPinPos.x && endLinePos.x <= logicalItem.inPinPos.x + pinSize &&
                        endLinePos.y >= logicalItem.inPinPos.y && endLinePos.y <= logicalItem.inPinPos.y + pinSize &&
                        canvas.checkConnection(logicalItem))
                    {
                        canvas.addLine(container, logicalItem)
                        logicalItem.pinConnect(true)
                        break
                    }
                }
            }

            isConnectable = false
            canvas.redraw()
        }
    }

    Rectangle
    {
        width: logicalItemSize - 40
        height: logicalItemSize - 20
        x: (logicalItemSize - width) / 2
        y: logicalItemSize - height - container.border.width

//        border
//        {
//            width: 2
//            color: "black"
//        }

        Image
        {
            source: "qrc:/images/LogicalItems/input.png"
            anchors.fill: parent
        }

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                isOn = !isOn
            }
        }
    }
}
