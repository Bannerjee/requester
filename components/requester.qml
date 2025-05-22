import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import "." 

Item
{
    Rectangle
    {
        id:exit_button
        height:50
        width:50
        anchors{topMargin:15;leftMargin:15;left:parent.left;top:parent.top}

        radius:10
        color: exit_button_area.containsMouse ? '#5865F2' : '#424549'

        ToolTip{text:"Return";delay:1000;visible:exit_button_area.containsMouse}
        Text 
        {
            text: "\u21B5"
            anchors.centerIn: parent
            font{bold:true;pointSize:24}
        }            

        MouseArea
        {
            id:exit_button_area
            hoverEnabled: true
            anchors.fill: parent
            onClicked:
            {
                main_stack_view.pop()
            }
        }
    }

    Rectangle
    {
        id:submit_request
        height:50
        width:50
        anchors{topMargin:15;rightMargin:15;right:parent.right;top:parent.top}

        radius:10
        color: submit_request_button_area.containsMouse ? '#5865F2' : '#424549'

        ToolTip{text:"Submit request";delay:1000;visible:submit_request_button_area.containsMouse}
        Text 
        {
        text: "\u0053"
        anchors.centerIn: parent
        font{bold:true;pointSize:24}
        }            

        MouseArea
        {
            id:submit_request_button_area
            hoverEnabled: true
            anchors.fill: parent
            function check_input(element, name) 
            {
                if(element.text.trim() == "") return true;
                try 
                {
                    JSON.parse(element.text);
                } 
                catch (e) 
                {
                    backend.info_message_box(`Invalid JSON payload for ${name}`)
                    return false
                }
                return true

            }
            onClicked:
            {
                if(url_input.text.trim() == "")
                {
                    backend.info_message_box("URL field cannot be empty")
                    return
                }
                const inputs = 
                [
                    { element: data_input, name: "data" },
                    { element: json_input, name: "JSON" },
                    { element: headers_input, name: "headers" },
                    { element: params_input, name: "params" },
                ];
                if(inputs.every(item => check_input(item.element, item.name)))
                {
                    backend.send_request(method_input.currentText,url_input.text,params_input.text,data_input.text,json_input.text,headers_input.text)
                }
            }
        }
    }
    RowLayout
    {
        anchors {right:parent.right;top:exit_button.bottom;left:parent.left}
        anchors{topMargin:15}
        spacing: 0
        Repeater
        {
            model:["Parameter","Value"]
            delegate:Rectangle
            {
                Layout.minimumHeight:25
                Layout.fillWidth:true
                color:"transparent"
                border{color:"#282b30";width:1}
                Label
                {
                    anchors{centerIn:parent}
                    text:modelData
                    color:"white"
                    font{bold:true;pixelSize:16}
                }
            }
        }
    }
    GridLayout
    {
        columns:2
        anchors.fill:parent
        uniformCellWidths:true
        anchors{left:parent.left;right:parent.right;bottom:parent.bottom}
        anchors{topMargin:85}
        Label
        {
            text:"Method"
            font.pixelSize:14
            color:"white" 
            Layout.leftMargin:15
        }
        CustomComboBox
        {
            id:method_input
            implicitHeight:20
            Layout.fillWidth:true
            model:["GET", 'OPTIONS', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE']
        }
        Label
        {
            text:"URL"
            font.pixelSize:14
            color:"white" 
            Layout.leftMargin:15
        }
        TextArea 
        {
            id:url_input
            Layout.fillWidth:true
            color:"white"
            height:20
            background: Rectangle 
            {
                color: "#333742"
                radius: 5 
                border{width:1;color:parent.activeFocus ? '#5865F2' : "#464a53"}
            }
        }      
        Label
        {
            text:"Params"
            font.pixelSize:14
            color:"white" 
            Layout.leftMargin:15
            
        }
        TextArea 
        {
            id:params_input
            Layout.fillWidth:true
            color:"white"
            background: Rectangle 
            {
                color: "#333742"
                radius: 5 
                border{width:1;color:parent.activeFocus ? '#5865F2' : "#464a53"}
            }
        }
        Label
        {
            text:"Data"
            font.pixelSize:14
            color:"white" 
            Layout.leftMargin:15
            
        }
        TextArea 
        {
            id:data_input
            Layout.fillWidth:true
            color:"white"
            background: Rectangle 
            {
                color: "#333742"
                radius: 5 
                border{width:1;color:parent.activeFocus ? '#5865F2' : "#464a53"}
            }
        }
        Label
        {
            text:"JSON"
            font.pixelSize:14
            color:"white" 
            Layout.leftMargin:15    
        }
        TextArea 
        {
            id:json_input
            Layout.fillWidth:true
            color:"white"
            background: Rectangle 
            {
                color: "#333742"
                radius: 5 
                border{width:1;color:parent.activeFocus ? '#5865F2' : "#464a53"}
            }
        }              
        Label
        {
            text:"Headers"
            font.pixelSize:14
            color:"white" 
            Layout.leftMargin:15
            
        }
        TextArea 
        {
            id:headers_input
            Layout.fillWidth:true
            color:"white"
            background: Rectangle 
            {
                color: "#333742"
                radius: 5 
                border{width:1;color:parent.activeFocus ? '#5865F2' : "#464a53"}
            }
        }
    }
}

