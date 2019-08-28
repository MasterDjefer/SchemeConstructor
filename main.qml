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

        property var lines: []

        property var activeItem: null
        property var activeArea: null
        property var endItem: null

        function addLine(item1, item2)
        {
            lines.push({"item1": item1, "item2": item2})
        }

        function removeLine(item1)
        {
            for (var i = 0; i < lines.length; ++i)
            {
                if (lines[i].item1 === item1)
                {
                    lines.splice(i, 1);
                }
            }
        }

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
            redraw();

            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(activeItem.startDrawPos.x, activeItem.startDrawPos.y);
            ctx.lineTo(activeArea.mouseX + activeItem.startDrawPos.x, activeArea.mouseY + activeItem.startDrawPos.y)
            ctx.stroke();

            canvas.requestPaint();
        }

        function redraw()
        {
            var ctx = getContext("2d");
            ctx.reset();
            for (var i = 0; i < lines.length; ++i)
            {
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.moveTo(lines[i].item1.startDrawPos.x, lines[i].item1.startDrawPos.y);
                ctx.lineTo(lines[i].item2.inConPos.x, lines[i].item2.inConPos.y + lines[i].item2.conSize / 2);
                ctx.stroke();
                canvas.requestPaint();
            }
        }
    }
}
