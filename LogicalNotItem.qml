import QtQuick 2.0

Rectangle
{
    id: container

    property bool isMoveable: false
    property int pinSize: 20
    property var posBeforeMove: {"x": 0, "y": 0}
    property var inPinPos: {"x": x + inPin.width / 2, "y": y + height / 2}
    property var outPinPos: {"x": container.x + container.width - pinSize / 2, "y": container.y + container.height / 2}

    width: 100
    height: 100

    border
    {
        width: 2
        color: "black"
    }

    Image
    {
        width: container.width - container.border.width * 2
        height: container.height - container.border.width * 2
        source: "qrc:/logicalNot.png"
        anchors.centerIn: parent
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered:
        {
            cursorShape = Qt.SizeAllCursor
        }

        onPressed:
        {
            isMoveable = true
            posBeforeMove.x = mouseX
            posBeforeMove.y = mouseY
        }
        onReleased:
        {
            isMoveable = false
        }

        onPositionChanged:
        {
            if (isMoveable)
            {
                container.x += mouseX - posBeforeMove.x
                container.y += mouseY - posBeforeMove.y
            }

            if (container.x < 0)
            {
                container.x = 0
            }
            if (container.y < 0)
            {
                container.y = 0
            }
            if (container.x + container.width > mainWindow.width)
            {
                container.x = mainWindow.width - container.width
            }
            if (container.y + container.height > mainWindow.height)
            {
                container.y = mainWindow.height - container.height
            }

            if (isMoveable)
            {
                canvas.redraw()
            }
        }
    }


    function inPinConnect(flag)
    {
        inPin.color = flag ? "grey" : "white"
    }

    Rectangle
    {
        id: inPin

        property bool isConnectable: false

        y: container.height / 2 - height / 2

        width: pinSize
        height: pinSize
        color: "white"
        radius: 100
        border
        {
            width: 1
            color: "black"
        }

        MouseArea
        {
            id: inPinArea
            anchors.fill: parent

            onPressed:
            {
                container.inPinConnect(false)
                var outItem = canvas.removeLine(container)
                inPin.isConnectable = !!outItem
                if (inPin.isConnectable)
                    canvas.setActiveItem(outItem, inPinArea, container) //TODO: mousearea cant pass
            }
            onReleased:
            {
                for (var i = 0; i < mainWindow.logicalItems.length; ++i)
                {
                    var item = mainWindow.logicalItems[i]
                    var releaseObj = {"x": inPinPos.x + mouseX, "y": inPinPos.y + mouseY}

                    if (releaseObj.x >= item.inPinPos.x && releaseObj.x <= item.inPinPos.x + inPin.width &&
                        releaseObj.y >= item.inPinPos.y && releaseObj.y <= item.inPinPos.y + inPin.height &&
                        canvas.outItem !== item) //check connection of the same item
                    {
                        canvas.addLine(canvas.outItem, item)
                        item.inPinConnect(true)
                        break
                    }
                }

                inPin.isConnectable = false
                canvas.redraw()
            }

            onPositionChanged:
            {
                if (inPin.isConnectable)
                {
                    canvas.drawLine()
                }
            }
        }
    }

    Rectangle
    {
        id: outPin

        property bool isConnectable: false

        x: container.width - width
        y: container.height / 2 - height / 2

        width: pinSize
        height: pinSize
        color: "white"
        radius: 100
        border
        {
            width: 1
            color: "black"
        }

        MouseArea
        {
            id: outPinArea
            anchors.fill: parent
            hoverEnabled:  true

            onEntered:
            {
                outPin.color = "grey"
            }
            onExited:
            {
                outPin.color = "white"
            }

            onPressed:
            {
                outPin.isConnectable = true
                canvas.setActiveItem(container, outPinArea)
            }
            onReleased:
            {
                for (var i = 0; i < mainWindow.logicalItems.length; ++i)
                {
                    var item = mainWindow.logicalItems[i]
                    var releaseObj = {"x": outPinPos.x + mouseX, "y": outPinPos.y + mouseY}

                    if (releaseObj.x >= item.inPinPos.x && releaseObj.x <= item.inPinPos.x + inPin.width &&
                        releaseObj.y >= item.inPinPos.y && releaseObj.y <= item.inPinPos.y + inPin.height &&
                        container !== item && canvas.checkConnection(item))
                    {
                        canvas.addLine(container, item)
                        item.inPinConnect(true)
                        break
                    }
                }

                outPin.isConnectable = false
                canvas.redraw()
            }

            onPositionChanged:
            {
                if (outPin.isConnectable)
                {
                    canvas.drawLine()
                }
            }
        }
    }

    Rectangle
    {
        id: a

        width: pinSize
        height: pinSize
        x: container.width - width - container.border.width
        y: container.border.width

        color: "#ddded6"

        Image
        {
            source: "qrc:/removeIcon.png"
            anchors.fill: parent
        }

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled:  true

            onEntered:
            {
                cursorShape = Qt.PointingHandCursor
            }

            onClicked:
            {
                mainWindow.destroyItem(container)
            }
        }
    }
}
