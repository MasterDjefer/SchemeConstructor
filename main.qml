import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    id: mainWindow

    visible: true
    width: 1000
    height: 700
    maximumHeight: height
    minimumHeight: height
    maximumWidth: width
    minimumWidth: width
    title: qsTr("Hello World")


    property var logicalItems: []


    Component.onCompleted:
    {
        var component = Qt.createComponent("LogicalOutputItem.qml")
        var item = component.createObject(mainWindow)
        item.x = canvas.width - item.width
        item.y = canvas.height / 2 - item.height / 2
        logicalItems.push(item)
    }


    function destroyItem(item)
    {
        for (var i = 0; i < canvas.lines.length;)
        {
            if (canvas.lines[i].item1 === item)
            {
                canvas.lines[i].item2.pinConnect[canvas.lines[i].pin](false)
                canvas.lines.splice(i, 1)
            }
            else
            if (canvas.lines[i].item2 === item)
            {
                canvas.lines.splice(i, 1)
            }
            else
            {
                i++
            }
        }

        logicalItems.splice(logicalItems.indexOf(item), 1)
        item.destroy()

        canvas.redraw()
    }

    Button
    {
        y: mainWindow.height - height

        onClicked:
        {
            var component = Qt.createComponent("LogicalNotItem.qml");
            var item = component.createObject(mainWindow);
            logicalItems.push(item)
        }
    }
    Button
    {
        x: width
        y: mainWindow.height - height

        onClicked:
        {
            var component = Qt.createComponent("LogicalAndItem.qml");
            var item = component.createObject(mainWindow);
            logicalItems.push(item)
        }
    }

    Rectangle
    {
        width: 3
        height: mainWindow.height
        x: canvas.width

        color: "black"
    }

    ControllBar
    {

    }

    Canvas
    {
        id: canvas
        width: mainWindow.width - 200//for sidebar
        height: mainWindow.height

//        anchors.fill: parent
//        z: 1

        property var lines: []

        property var outItem: null
        property var outArea: null
        property int currentPin: -1
        property var inItem: null

        function addLine(item1, item2, pin)
        {
            for (var i = 0; i < lines.length; ++i)
            {
                if (lines[i].item1 === item1 && lines[i].item2 === item2 && lines[i].pin === pin)
                {
                    return
                }
            }

            lines.push({"item1": item1, "item2": item2, "pin": pin})
        }

        function checkConnection(item, pin)
        {
            for (var i = 0; i < lines.length; ++i)
            {
                if (lines[i].item2 === item && pin === lines[i].pin)
                {
                    return false
                }
            }

            return true
        }

        function removeLine(item, pin)
        {
            for (var i = lines.length - 1; i >= 0; --i)
            {
                if (lines[i].item2 === item && lines[i].pin === pin)
                {
                    var currentItem = lines[i].item1
                    lines.splice(i, 1)
                    return currentItem
                }
            }
        }

        function setActiveItem(outItem, outArea, currentPin, inItem) //third param if draw from inPin
        {
            canvas.outItem = outItem
            canvas.outArea = outArea
            canvas.currentPin = currentPin
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
            {
                ctx.lineTo(outArea.mouseX + inItem.inPinPos[currentPin].x, outArea.mouseY + inItem.inPinPos[currentPin].y)
            }

            ctx.stroke()

            canvas.requestPaint()
        }

        function redraw()
        {
            var ctx = getContext("2d")
            ctx.reset()
            canvas.requestPaint()

            for (var i = 0; i < lines.length; ++i)
            {
                ctx.lineWidth = 2;
                ctx.beginPath();

                ctx.moveTo(lines[i].item1.outPinPos.x, lines[i].item1.outPinPos.y)

                ctx.lineTo(lines[i].item2.inPinPos[lines[i].pin].x, lines[i].item2.inPinPos[lines[i].pin].y);

                ctx.stroke();
                canvas.requestPaint();
            }
        }
    }
}
