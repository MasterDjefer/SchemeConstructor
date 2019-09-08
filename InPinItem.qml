import QtQuick 2.0

BasePinItem
{
    id: pin
    property int pinNumber: 0 //0 - single, 1 - first, 2 - second
                              //(for out pin only) 0 - element with one in, 1 - first in pin, 2 - second pin

    function pinConnect(flag)
    {
        color = flag ? "grey" : "white"
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled:  true

        onPressed:
        {
            pinConnect(false)
            var outItem = canvas.removeLine(father, pinNumber)
            isConnectable = !!outItem
            if (isConnectable)
                canvas.setActiveItem(outItem, mouseArea, pinNumber, father)
        }
        onReleased:
        {
            for (var i = 0; i < mainWindow.logicalItems.length; ++i)
            {
                var logicalItem = mainWindow.logicalItems[i]
                if (!canvas.outItem || canvas.outItem === logicalItem)
                {
                    continue
                }

                var endLinePos = {"x": father.inPinPos[pinNumber].x + mouseArea.mouseX,
                                  "y": father.inPinPos[pinNumber].y + mouseArea.mouseY}

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
                            canvas.addLine(canvas.outItem, logicalItem, j)
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
