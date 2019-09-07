import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Rectangle
{
    id: controllBar
    property int spaceValue: 20

    width: mainWindow.width - canvas.width - spaceValue
    height: width * 0.6
    x: canvas.width + spaceValue / 2
    y: spaceValue / 2

    color: "#eef8e8"

    ColumnLayout
    {
        width: parent.width - controllBar.spaceValue
        height: parent.height - controllBar.spaceValue
        anchors.centerIn: parent
        ComboBox
        {
            id: logicalItemsBox

            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillWidth: true

            model: ListModel {
                ListElement { text: "Input" }
                ListElement { text: "Not" }
                ListElement { text: "And" }
                ListElement { text: "Nand" }
                ListElement { text: "Or" }
                ListElement { text: "Nor" }
                ListElement { text: "Xor" }
            }
        }

        Button
        {
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillWidth: true
            text: "Add node"

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    var component = Qt.createComponent("Logical" + logicalItemsBox.currentText + "Item.qml")
                    var item = component.createObject(mainWindow)
                    mainWindow.logicalItems.push(item)
                }
            }
        }
    }

}
