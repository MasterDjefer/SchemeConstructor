import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    id: mainWindow

    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")


    LogicalNotItem
    {
        id: logicalNotItem
    }

    Button
    {
        y: 300

        onClicked:
        {
            var component = Qt.createComponent("LogicalNotItem.qml");
            component.createObject(mainWindow);
        }
    }

    Canvas
    {
        id: canvas

        width: 640
        height: 480

        property var activeItem: null
        property var activeArea: null

        function setActiveItem(item, area)
        {
            activeItem = item
            activeArea = area
        }

        function clear()
        {
            var ctx = getContext("2d");
            ctx.reset();

            canvas.requestPaint();
        }

        function drawLine()
        {
            var ctx = getContext("2d");
            ctx.reset();

            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(activeItem.startDrawPos.x, activeItem.startDrawPos.y);
            ctx.lineTo(activeArea.mouseX + activeItem.startDrawPos.x, activeArea.mouseY + activeItem.startDrawPos.y)
            ctx.stroke();

            canvas.requestPaint();
        }
    }
}
