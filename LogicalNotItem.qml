import QtQuick 2.0

LogicalBaseItem
{
    id: container

    imgPath: "qrc:/images/LogicalItems/logicalNot.png"
    type: 2

    property var inPinPos: {"x": x, "y": y + height / 2}
    property var outPinPos: {"x": x + width, "y": y + height / 2}
    property var pinConnect: inPin.pinConnect


    PinItem
    {
        id: inPin

        x: - pinSize / 2
        y: logicalItemSize / 2 - pinSize / 2
        father: container
        type: "in"

        onPressedFunc: function()
        {
            pinConnect(false)
            var outItem = canvas.removeLine(container)
            isConnectable = !!outItem
            if (isConnectable)
                canvas.setActiveItem(outItem, pinArea, container) //TODO: mousearea cant pass
        }

        onReleasedFunc: function()
        {
            for (var i = 0; i < mainWindow.logicalItems.length; ++i)
            {
                var logicalItem = mainWindow.logicalItems[i]
                if (canvas.outItem === logicalItem)
                {
                    continue
                }

                var endLinePos = {"x": inPinPos.x + pinArea.mouseX, "y": inPinPos.y + pinArea.mouseY}

                if (logicalItem.type === 2)
                {
                    if (endLinePos.x >= logicalItem.inPinPos.x && endLinePos.x <= logicalItem.inPinPos.x + pinSize &&
                        endLinePos.y >= logicalItem.inPinPos.y && endLinePos.y <= logicalItem.inPinPos.y + pinSize)
                    {
                        canvas.addLine(canvas.outItem, logicalItem)
                        logicalItem.pinConnect(true)
                        break
                    }
                }
            }

            isConnectable = false
            canvas.redraw()
        }
    }


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

    DestroyItem
    {
        father: container
    }
}
