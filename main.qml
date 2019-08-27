import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    id: mainWindow

    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property var logicalItems: []

    Button
    {
        y: 300

        onClicked:
        {
            var component = Qt.createComponent("LogicalNotItem.qml");
            var item = component.createObject(mainWindow);
            logicalItems.push(item)
        }
    }

    Canvas
    {
        id: canvas

        width: 640
        height: 480
        z: 1

        property var activeItem: null
        property var activeArea: null
        property var endItem: null

        function setActiveItem(item, area, last)
        {
            activeItem = item
            activeArea = area
            endItem = last
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
            if (endItem)
                ctx.lineTo(endItem.inConPos.x, endItem.inConPos.y + endItem.conSize / 2)
            else
                ctx.lineTo(activeArea.mouseX + activeItem.startDrawPos.x, activeArea.mouseY + activeItem.startDrawPos.y)
            ctx.stroke();

            canvas.requestPaint();
        }
    }
}
