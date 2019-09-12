import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Package.LogicalItemsMap 1.0
import Package.LogicalItemsParser 1.0

Window
{
    id: mainWindow
    objectName: "mainWindow"

    visible: true
    width: 1000
    height: 700
    maximumHeight: height
    minimumHeight: height
    maximumWidth: width
    minimumWidth: width
    title: qsTr("Scheme constructor")

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

        canvas.sendConnections()
    }

    function clearField()
    {
        canvas.lines = []
        canvas.redraw()

        for (var i = 0; i < logicalItems.length; ++i)
        {
            logicalItems[i].destroy()
        }

        logicalItems = []
    }

    function createItems(data)
    {
        clearField();
        for (var i = 0; i < data.length; ++i)
        {
            var component = null
            if (data[i].type === "Input" || data[i].type === "Output" || data[i].type === "Not")
            {
                component = Qt.createComponent("Logical" + data[i].type + "Item.qml")
            }
            else
            {
                component = Qt.createComponent("LogicalTwoPinItem.qml")
            }

            var item = component.createObject(mainWindow)
            item.x = data[i].x
            item.y = data[i].y
            item.name = data[i].name

            if (item.logicalType === 3)
            {
                item.imgPath = "qrc:/images/LogicalItems/logical" + data[i].type + ".png"
            }

            mainWindow.logicalItems.push(item)
        }
    }

    function findItemByName(name)
    {
        for (var i = 0; i < logicalItems.length; ++i)
        {
            if (logicalItems[i].name === name)
            {
                return logicalItems[i]
            }
        }
    }

    function createConnections(data)
    {
        for (var i = 0; i < data.length; ++i)
        {
            var item1 = findItemByName(data[i].item1)
            var item2 = findItemByName(data[i].item2)
            var pin = data[i].pin

            canvas.lines.push({"item1": item1, "item2": item2, "pin": pin})
            item2.pinConnect[pin](true)
        }
        canvas.redraw()
        canvas.sendConnections()
    }

    function countItemByName(name)
    {
        var count = 0

        for (var i = 0; i < logicalItems.length; ++i)
        {
            if (logicalItems[i].name.search(name) !== -1)
            {
                count++
            }
        }

        return count
    }


    Rectangle
    {
        id: barSeparator

        width: 3
        height: mainWindow.height
        x: canvas.width

        color: "black"
    }

    ControllBar
    {
        id: controllBar
    }

    MessageDialog
    {
        id: messageInfinineLoop

        icon: StandardIcon.Critical
        title: "Error"
        text: "Whoops! It looks like there is an infinite loop in this set up. Please remove it and try again."
    }

    LogicalItemsMap
    {
        id: logicalItemsMap

        onEndMeasurement:
        {
            if (value >= 0)
            {
                findItemByName("Output").isOn = Boolean(value)
            }
            else
            {
                messageInfinineLoop.open()
            }
        }
    }

    LogicalItemsParser
    {
        id: logicalItemsParser

        onItemsParsed:
        {
            createItems(data)
        }
        onConnectionsParsed:
        {
            createConnections(data)
        }
    }

    DrawingField
    {
        id: canvas
    }

    FileDialog
    {
        id: openFileDialog
        title: "Please choose a file"
        folder: shortcuts.home
//        selectExisting: false
        nameFilters: "*.lif"
//        Component.onCompleted: visible = true
        onAccepted:
        {
//            logicalItemsParser.openFile(fileDialog.fileUrl.toString())  //url/urls
        }
    }
}
