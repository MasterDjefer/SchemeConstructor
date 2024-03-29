import QtQuick 2.0

Rectangle
{
    id: pin

    property var father: null
    property bool isConnectable: false
    property int pinSize: 20

    width: pinSize
    height: pinSize
    color: "white"
    radius: 100
    border
    {
        width: 1
        color: "black"
    }

    function releaseEventEnd()
    {
        isConnectable = false
        canvas.setActiveItem(null, null, -1, null)
        canvas.redraw()

        canvas.sendConnections()
    }
}
