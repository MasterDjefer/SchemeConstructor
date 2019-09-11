import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Package.LogicalItemsMap 1.0

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

    signal logicalItemsMap(var data)

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
                logicalItems[0].isOn = Boolean(value) //first element in array - output(with property isOn)
            }
            else
            {
                messageInfinineLoop.open()
            }
        }
    }

    DrawingField
    {
        id: canvas
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
//            Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
//            Qt.quit()
        }
    }
}
