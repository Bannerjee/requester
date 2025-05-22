import QtQuick.Controls.Basic
import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Dialogs

ApplicationWindow 
{

    id: window

    width: 800
    height: 800
    minimumWidth:400
    minimumHeight:400


    visible: true
    color: "#121212"
    flags: Qt.FramelessWindowHint | Qt.Window

    MouseArea 
    {
        id: move_area

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 10
        cursorShape: Qt.OpenHandCursor

        DragHandler
        {
            target:null
            onActiveChanged:window.startSystemMove()
        }
    }

    MouseArea 
    {
        id: resize_area
        width: 20
        height: 20
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeFDiagCursor

        DragHandler
        {
            target:null
            onActiveChanged:if(active){window.startSystemResize(Qt.RightEdge | Qt.BottomEdge)}
        }
       
    }
    StackView
    {
        id:main_stack_view
        anchors.fill:parent
        initialItem:"list.qml"
    }   
}