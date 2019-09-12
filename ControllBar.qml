import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Rectangle
{
    id: controllBar
    property int spaceValue: 20

    width: mainWindow.width - canvas.width - spaceValue
    height: width * 0.8
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
            Layout.fillWidth: true
            text: "Add node"

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    var component = logicalItemsBox.currentIndex < 2 ?
                                component = Qt.createComponent("Logical" + logicalItemsBox.currentText + "Item.qml") :
                                component = Qt.createComponent("LogicalTwoPinItem.qml")
                    var item = component.createObject(mainWindow)

                    if (item.logicalType === 3)
                    {
                        item.imgPath = "qrc:/images/LogicalItems/logical" + logicalItemsBox.currentText + ".png"
                    }

                    var count = mainWindow.countItemByName(logicalItemsBox.currentText)
                    item.name = logicalItemsBox.currentText + (count + 1)
                    mainWindow.logicalItems.push(item)
                }
            }
        }

        Button
        {
            Layout.fillWidth: true
            text: "Import"

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    //    QString fName = "D:/Projects/C/Qt/SchemeConstructor/examples/example1.lif";
                    //#elif __linux__
                    //    QString fName = "/home/predator/Programs/Qt/SchemeConstructor/examples/example1.lif";
                    logicalItemsParser.openFile("D:/Projects/C/Qt/SchemeConstructor/examples/example1.lif")
//                    openFileDialog.open()
                }
            }
        }

        Button
        {
            Layout.fillWidth: true
            text: "Export"

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                }
            }
        }
    }
}
