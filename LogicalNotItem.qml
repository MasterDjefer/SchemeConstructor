import QtQuick 2.0

Rectangle
{
    id: container

    property bool isMoveable: false
    property var startPos: {"x": 0, "y": 0}

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
            }
        }
    }

    Rectangle
    {
        id: inCon

        y: container.height / 2 - height / 2

        width: 20
        height: 20
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

        function f()
        {

        }

        width: 20
        height: 20
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
                canvas.setActiveItem(outCon, outConArea)
            }
            onReleased:
            {
                isMoveable = false
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
