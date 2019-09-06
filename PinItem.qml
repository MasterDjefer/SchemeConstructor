import QtQuick 2.0

Rectangle
{
    id: pin

    property var father: null
    property bool isConnectable: false
    property string type: "out"
    property var onPressedFunc: null
    property var onReleasedFunc: null

    property var pinArea: mouseArea

    width: father.pinSize
    height: father.pinSize
    color: "white"
    radius: 100
    border
    {
        width: 1
        color: "black"
    }

    function pinConnect(flag)
    {
        color = flag ? "grey" : "white"
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled:  true

        onEntered:
        {
            if (type === "out")
            {
                pin.color = "grey"
            }
        }
        onExited:
        {
            if (type === "out")
            {
                pin.color = "white"
            }
        }

        onPressed:
        {
            onPressedFunc()
        }
        onReleased:
        {
            onReleasedFunc()
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
