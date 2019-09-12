import QtQuick 2.0

BasePinItem
{
    id: pin

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled:  true

        onEntered:
        {
            pin.color = "grey"
        }
        onExited:
        {
            pin.color = "white"
        }

        onPressed:
        {
            isConnectable = true
            canvas.setActiveItem(father, mouseArea, 0)
        }
        onReleased:
        {
            for (var i = 0; i < mainWindow.logicalItems.length; ++i)
            {
                var logicalItem = mainWindow.logicalItems[i]
                if (container === logicalItem)
                {
                    continue
                }

                var endLinePos = {"x": father.outPinPos.x + mouseArea.mouseX, "y": father.outPinPos.y + mouseArea.mouseY}

                if (logicalItem.logicalType > 1)
                {
                    for (var j = 0; j < 3; ++j)
                    {
                        if (!logicalItem.inPinPos[j])
                            continue


                        if (endLinePos.x >= logicalItem.inPinPos[j].x && endLinePos.x <= logicalItem.inPinPos[j].x + pinSize &&
                            endLinePos.y >= logicalItem.inPinPos[j].y && endLinePos.y <= logicalItem.inPinPos[j].y + pinSize &&
                            canvas.checkConnection(logicalItem, j))
                        {
                            canvas.addLine(father, logicalItem, j)
                            logicalItem.pinConnect[j](true)

                            releaseEventEnd()
                            return
                        }
                    }
                }
            }

            releaseEventEnd()
        }

        onPositionChanged:
        {
            if (isConnectable)
            {
                canvas.drawLine()
            }
        }
    }
}
