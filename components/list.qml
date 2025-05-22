import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Dialogs

Item
{
    ColumnLayout 
    {
        anchors {right:parent.right;bottom:parent.bottom;top:parent.top;left:side_bar.right}
        ListView 
        {
            id: file_list
            highlight: highlight
            highlightFollowsCurrentItem: false
            focus: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: file_model
            delegate: Rectangle 
            {
                width: file_list.width
                
                height: (file_list.currentIndex == index ? col_layout.implicitHeight : (window.height /  20))
                color: file_list.currentIndex == index ? "#424549": "#2c2f33" 
                border{color:"#7289da";width:1}
                anchors.bottomMargin:10

                RowLayout 
                {
                    visible:file_list.currentIndex != index 
                    Layout.alignment: Qt.AlignRight
                    anchors{fill:parent;bottomMargin:20;leftMargin:20;rightMargin:20}
                    Repeater 
                    {
                    Layout.fillWidth:true
                    Layout.fillHeight:true
                    model: [
                    {text:"Method:%1".arg(method),width:20},
                    {text:"Status:%1".arg(status),width:20},
                    {text:"URL:%1".arg(url),width:60}
                    ]
                    delegate:Text 
                    {
                          
                        elide: Text.ElideRight
                        Layout.topMargin:10
                        Layout.fillWidth:true
                        Layout.preferredWidth: modelData.width
                        text: modelData.text
                        color: "white"
                        font.pointSize: 12    
                    }
                    }
                }
                Behavior on height 
                {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                ColumnLayout
                {
                    id:col_layout
                    visible:file_list.currentIndex == index 
                    Layout.alignment: Qt.AlignRight
                    anchors{fill:parent;bottomMargin:20;leftMargin:20;rightMargin:20}
                    Repeater 
                    {
                    Layout.fillWidth:true
                    Layout.fillHeight:true
                    model: [
                        "Method:%1".arg(method),
                        "Status:%1".arg(status),
                        "URL:%1".arg(url),
                        "Data:%1".arg(DATA),
                        "JSON:%1".arg(json),
                        "Headers:%1".arg(headers),
                        "Params:%1".arg(params),
                        "Text:%1".arg(text)
                    ]
                    delegate:Rectangle 
                    {
                        height: childrenRect.height
                        Text 
                        {   
                            elide: Text.ElideRight
                            Layout.fillWidth:true
                            wrapMode: Text.WrapAnywhere
                            text: modelData
                            color: "white"
                            font.pointSize: 12
                        }
                    }
                    }

                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: 
                    {

                        if(file_list.currentIndex == index)
                        {
                            file_list.currentIndex = -1;
                        }
                        else
                        {
                            file_list.currentIndex = index;
                        }
                    }
                }
            }

        }
    }

  
    FileDialog
    {
        id:export_file_dialog
        title: "Export file dialog"
        fileMode: FileDialog.SaveFile
        onAccepted:
        {
            backend.export(export_file_dialog.selectedFile,file_list.currentIndex)
        }
    }
     
    Rectangle 
    {
        id: side_bar
        width: 80
        height: parent.height
        anchors.left:parent.left
        radius: 10
        color: '#282b30'

        ColumnLayout
        {
            Repeater
            {
                model:[
                { name:"request",   icon:"\u27A4",  hint:"Create request"},
                { name:"export",    icon:"\u0045",  hint:"Export data"},
                { name:"exit",      icon:"\u2716",  hint:"Exit app"}]

                delegate:Rectangle
                {
                    Layout.preferredHeight:50
                    Layout.preferredWidth:50
                    Layout.topMargin: 20
                    Layout.leftMargin:15
                    Layout.alignment:Qt.AlignBottom

                    radius:10
                    color: side_button_mouse_area.containsMouse ? '#5865F2' : '#424549'
    
                    ToolTip{text:modelData.hint;delay:1000;visible:side_button_mouse_area.containsMouse}
                    Text 
                    {
                        text: modelData.icon
                        anchors.centerIn: parent
                        font{bold:true;pointSize:24}
                    }
                                
                    
                    MouseArea
                    {
                        id:side_button_mouse_area
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:
                        {
                            switch(modelData.name)
                            {
                                case "export":
                                    if(file_list.currentIndex == -1)
                                    {
                                        backend.info_message_box("Select item to export")
                                    }
                                    else
                                    {
                                        export_file_dialog.open()
                                    }
                                    break;
                                case "request":
                                    main_stack_view.push("requester.qml")
                                    break;
                                case "exit":
                                    Qt.exit(0)
                                    break;
                            }

                        }
                    }
                }
            }
        }   
    } 
}