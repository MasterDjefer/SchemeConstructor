import QtQuick 2.0

Canvas
{
    width: mainWindow.width - 200//for sidebar
    height: mainWindow.height

//        z: 1

    property var lines: []

    property var outItem: null
    property var outArea: null
    property int currentPin: -1
    property var inItem: null


    function sendConnections()
    {
        var itemsMap = []
        for (var i = 0; i < lines.length; ++i)
        {
            var value = lines[i].item1.name.search("Input") !== -1 ? lines[i].item1.isOn : -1
            itemsMap.push({"out": lines[i].item1.name, "value": value, "in": lines[i].item2.name, "pin": lines[i].pin})
        }
        logicalItemsMap.getLogicalItemsMap(itemsMap) //C++ object's method call
    }

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

    function setActiveItem(outItem, outArea, currentPin, inItem) //fourth param if draw from inPin
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
