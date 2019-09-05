import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    id: mainWindow

    visible: true
    width: 640
    height: 480
    maximumHeight: height
    minimumHeight: height
    maximumWidth: width
    minimumWidth: width
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

        anchors.fill: parent
        z: 1

        property var lines: []

        property var outItem: null
        property var outArea: null
        property var inItem: null

        function addLine(item1, item2)
        {
            var flag = false
            for (var i = 0; i < lines.length; ++i)
            {
                if (lines[i].item1 === item1 && lines[i].item2 === item2)
                {
                    flag = true
                    break
                }
            }

            if (!flag)
            {
                lines.push({"item1": item1, "item2": item2})
            }
        }

        function checkConnection(item)
        {
            for (var i = 0; i < lines.length; ++i)
            {
                if (lines[i].item2 === item)
                {
                    return false
                }
            }

            return true
        }

        function removeLine(item)
        {
            for (var i = lines.length - 1; i >= 0; --i)
            {
                if (lines[i].item2 === item)
                {
                    var currentItem = lines[i].item1
                    lines.splice(i, 1)
                    return currentItem
                }
            }
        }

        function setActiveItem(outItem, outArea, inItem) //third param if draw from inPin
        {
            canvas.outItem = outItem
            canvas.outArea = outArea
            canvas.inItem= inItem
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
            redraw();

            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(outItem.outPinPos.x, outItem.outPinPos.y);
            if (!inItem)
                ctx.lineTo(outArea.mouseX + outItem.outPinPos.x, outArea.mouseY + outItem.outPinPos.y)
            else
                ctx.lineTo(outArea.mouseX + inItem.inPinPos.x, outArea.mouseY + inItem.inPinPos.y)
            ctx.stroke();

            canvas.requestPaint();
        }

        function redraw()
        {
            var ctx = getContext("2d");
            ctx.reset();
            canvas.requestPaint();
            for (var i = 0; i < lines.length; ++i)
            {
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.moveTo(lines[i].item1.outPinPos.x, lines[i].item1.outPinPos.y);
                ctx.lineTo(lines[i].item2.inPinPos.x, lines[i].item2.inPinPos.y);
                ctx.stroke();
                canvas.requestPaint();
            }
        }
    }
}
