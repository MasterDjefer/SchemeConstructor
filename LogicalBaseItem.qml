import QtQuick 2.0

Rectangle
{
    id: container

    property bool isMoveable: false
    property var posBeforeMove: {"x": 0, "y": 0}
    property int logicalItemSize: 100

    property string imgPath: ""
    property int logicalType: 0 //1 - only out Pin, 2 - only in pin or both, 3 - two in pins and out pin

    width: logicalItemSize
    height: logicalItemSize

    border
    {
        width: 2
        color: "black"
    }

    Image
    {
        width: container.width - container.border.width * 2
        height: container.height - container.border.width * 2
        source: imgPath
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
}
