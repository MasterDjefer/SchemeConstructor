import QtQuick 2.0

Rectangle
{
    id: container

    property bool isMoveable: false
    property var startPos: {"x": 0, "y": 0}
    property var inConPos: {"x": x + inCon.width - inCon.width / 2, "y": y + height / 2 - inCon.height / 2}
    property int conSize: 20

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

    Component.onCompleted:
    {
        canvas.setActiveItem(outCon, outConArea, null)
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
            startPos.x = mouseX
            startPos.y = mouseY
        }
        onReleased:
        {
            isMoveable = false
        }

        onPositionChanged:
        {
            if (isMoveable)
            {
                container.x += mouseX - startPos.x
                container.y += mouseY - startPos.y

                canvas.drawLine()
            }
        }
    }

    Rectangle
    {
        id: inCon

        y: container.height / 2 - height / 2

        width: conSize
        height: conSize
        color: "white"
        radius: 100
        border
        {
            width: 1
            color: "black"
        }

        MouseArea
        {
            anchors.fill: parent
        }
    }

    Rectangle
    {
        id: outCon

        property bool isMoveable: false
        property var startDrawPos: {"x": container.x + container.width - width / 2, "y": container.y + container.height / 2}

        x: container.width - width
        y: container.height / 2 - height / 2

        width: conSize
        height: conSize
        color: "white"
        radius: 100
        border
        {
            width: 1
            color: "black"
        }

        MouseArea
        {
            id: outConArea
            anchors.fill: parent
            hoverEnabled:  true

            onEntered:
            {
                outCon.color = "grey"
            }
            onExited:
            {
                outCon.color = "white"
            }

            onPressed:
            {
                isMoveable = true
                canvas.setActiveItem(outCon, outConArea, null)
            }
            onReleased:
            {
                var isConnected = false
                for (var i = 0; i < mainWindow.logicalItems.length; ++i)
                {
                    var item = mainWindow.logicalItems[i]
                    var releaseObj = {"x": container.x + mouseX + container.width, "y": container.y + mouseY + container.height / 2}

                    if (releaseObj.x >= item.inConPos.x && releaseObj.x <= item.inConPos.x + inCon.width &&
                        releaseObj.y >= item.inConPos.y && releaseObj.y <= item.inConPos.y + inCon.height &&
                        container !== item)
                    {
                        isConnected = true
                        canvas.setActiveItem(outCon, outConArea, item)
                        canvas.drawLine()
                    }
                }

                isMoveable = false

                if (!isConnected)
                    canvas.clear()
            }

            onPositionChanged:
            {
                if (isMoveable)
                    canvas.drawLine()
            }
        }
    }
}
