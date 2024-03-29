import QtQuick 2.0

Rectangle
{
    color: "#ddded6"

    property var father: null
    property int destroyItemSize: 20

    width: destroyItemSize
    height: destroyItemSize
    x: father.width - width - father.border.width
    y: father.border.width

    Image
    {
        source: "qrc:/images/Tools/removeIcon.png"
        anchors.fill: parent
    }

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled:  true

        onEntered:
        {
            cursorShape = Qt.PointingHandCursor
        }

        onClicked:
        {
            mainWindow.destroyItem(father)
        }
    }
}
