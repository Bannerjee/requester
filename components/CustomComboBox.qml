
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ComboBox 
{
    id: root
    model: ["one", "two", "three", "four"]

    implicitWidth: 55
    implicitHeight: 300

    delegate: ItemDelegate 
    {
        width: root.implicitWidth
        height: root.implicitHeight
        hoverEnabled: true

        background: Rectangle 
        {
            anchors.fill:parent
            anchors.rightMargin:15
            radius:10
            color: parent.hovered ? "#2a2d36" : "transparent"
        }

        RowLayout 
        {
            Layout.alignment: Qt.AlignVCenter
            anchors.fill:parent

            Label 
            {
                opacity: 0.9
                text: modelData
                font.pixelSize: 12
                color: "white"
                Layout.fillWidth: true

                Layout.leftMargin: 10
            }
        }
    }
    contentItem: Item 
    {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight
        RowLayout 
        {
            anchors.fill: parent
            Label 
            {
                opacity: 0.9
                text: root.displayText
                font.pixelSize: 12
                Layout.fillWidth: true
                Layout.leftMargin: 10
                color: "#FFFFFF"
            }
        }
    }

    background: Rectangle 
    {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight
        color: root.down ? Qt.darker("#333742", 1.2) : "#333742"
        radius: 10
        border.width: root.activeFocus ? 2 : 0.6
        border.color: root.activeFocus ? '#5865F2' : "#464a53"
    }

    popup: Popup 
    {
        y: root.height
        width: root.width 
        implicitHeight: contentItem.implicitHeight > 250 ? 250 : contentItem.implicitHeight
        padding: 4
        contentItem: ListView 
        {
            leftMargin: 5
            implicitHeight: contentHeight
            keyNavigationEnabled: true
            model: root.popup.visible ? root.delegateModel : null
            clip: true
            focus: true
            currentIndex: root.highlightedIndex
        }

        background: Rectangle {
            anchors.fill: parent
            color: "#333742"
            radius: 10
            border.width: 0.6
            border.color: "#464a53"
            clip: true
        }
    }
}