import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import fr.nconcepts 1.0

ApplicationWindow {
    id: mainWindow

    property real shaderIndex: 0
    property double startTime: 0
    property bool cleanFaces: true;

    visible: true;
    color: "transparent"
    width: 1200
    height: 1000

    Rectangle {
        id: mainScreen

        width: parent.width / 1.75
        height:parent.height
        OCVRenderer {
            id: mediaplayer

            anchors {
                top:parent.top; topMargin : 0; fill:parent;
            }
            width: parent.width
            height:parent.height
            fillMode: OCVRenderer.PreserveAspectCrop
            mode: "camera"
            cameraId: 0
            cameraWidth: parent.width
            cameraHeight: parent.height
            videoSource: "camera"
            loop: true
            fps: 30

            Component.onCompleted: {
                console.log("YO")
                mediaplayer.start();
            }
        }

        MouseArea {
            id: idModuleMouseDebug;

            parent: mainScreen;
            anchors.fill: parent;
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onMouseXChanged: {
                shader.mouseXPos = mouseX / shader.width
            }
            onMouseYChanged: {
                shader.mouseYPos = mouseY / shader.height
            }
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    console.log("YO1")
                    if (timer.running) {
                        dblClick()
                        timer.stop()
                    }
                    else{
                        timer.restart()
                    }
                }
            }
            Timer{
                id:timer
                interval: 200
                onTriggered: singleClick()
            }
        }

//        FaceDetection{
//            id: faceDetector
//            haarCascade: "/usr/local/Cellar/opencv/4.4.0_2/share/opencv4/haarcascades/haarcascade_frontalface_alt2.xml"
//            onFacesChanged: {
//                shader.face_x = -1;
//                shader.face_y = -1;
//                shader.face_width = -1;
//                shader.face_height = -1;
//                cleanFaces = false;

//                var faces = getFoundFaces()
//                shader.face_count = faces.length;

//                for (var i = 0; i < faces.length; i++){
//                    var face = faces[i]
//                    shader.face_x= (face.x) / shader.width
//                    shader.face_y= (face.y) / shader.height
//                    shader.face_width = face.width / shader.width
//                    shader.face_height = face.height / shader.height
//                }
//            }
//            debugMode: false;

//            Component.onCompleted: {
//                console.log("FaceDetection Completed")
//            }
//        }

//        Timer {
//            interval: 100; running: true; repeat: true
//            onTriggered: {
//                cleanFaces = true;
//                faceDetector.runFaceDetection(mediaplayer.frame)
//            }
//        }

        Effect {
            id:shader

            property var face_count : 0;
            property var face_x : -1;
            property var face_y : -1;
            property var face_width : -1;
            property var face_height : -1;
            property real u_time: shaderManager.u_time
            property real grid: 2
            property real dividerValue: 1
            property real mouseXPos: -1
            property real mouseYPos: -1
            property real step_x: 0.015625
            property real step_y: step_x * 640 / 480
            property real qt_opacity: 0.5
            property variant source: mediaplayer
            property real blurSize : 0.3

            fragmentShaderFilename: shaderManager.shaders[0]
        }

        Rectangle {
            id: rectangle

            width: parent.width
            height: 73
            x: 0
            color: "#000000"
            anchors {
                top:parent.top; topMargin: 0;
            }

            Text {
                id: shaderName
                x: 0
                y: 0
                width: parent.width
                height: parent.height
                color: "#ffffff"
                text: shaderManager.shaders[0]
                font {
                    family: "Arial"; bold: true; pixelSize: 25
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                Button {
                    id: button2

                    anchors {
                        top :parent.top; topMargin: 20; left:parent.right; leftMargin: -100;
                    }
                    text: qsTr("Next")

                    onClicked: {
                        if (shaderIndex < shaderManager.shaders.length - 1) {
                            shaderIndex++
                        } else {
                            shaderIndex = 0;
                        }

                        shaderName.text = shaderManager.shaders[shaderIndex]
                        shaderManager.changeShader(shaderManager.shaders[shaderIndex]);
                        shader.fragmentShaderFilename = shaderManager.shaders[shaderIndex];
                        shaderCode.text = shaderManager.code;
                        Effect.fragmentShader = shaderManager.code;
                    }
                }

                Button {
                    id: button3

                    anchors {
                        top :parent.top; topMargin: 20; left:parent.left; leftMargin: 50;
                    }
                    text: qsTr("Previous")

                    onClicked: {
                        if (shaderIndex > 0) {
                            shaderIndex--;
                        }
                        else {
                            shaderIndex = shaderManager.shaders.length - 1
                        }

                        shaderName.text = shaderManager.shaders[shaderIndex]
                        shaderManager.changeShader(shaderManager.shaders[shaderIndex]);
                        shader.fragmentShaderFilename = shaderManager.shaders[shaderIndex];
                        shaderCode.text = shaderManager.code;
                        Effect.fragmentShader = shaderManager.code;
                    }
                }
            }
        }
    }

    Rectangle {
        id: rectangle1

        color: "#00000000"
        anchors {
            right :parent.right; rightMargin: 0;
            left:mainScreen.right; leftMargin: 0;
            top:parent.top; topMargin: 0;
            bottom:parent.bottom; bottomMargin: 0;
        }

        TextArea {
            id: shaderCode

            focus:true
            text: shaderManager.code
            anchors {
                right :parent.right; rightMargin: 0;
                left:parent.left; leftMargin: 0;
                top:parent.top; topMargin: 0;
                bottom:parent.bottom; bottomMargin: 50;
            }
            font.pixelSize: 15
        }

        Button {
            id: button

            text: qsTr("SAVE")
            anchors {
                left:shaderCode.left; leftMargin: 50;
                bottom:parent.bottom; bottomMargin: 15;
            }
            onClicked: {
                shaderManager.save(shaderCode.text);
            }
        }

        Button {
            id: button1

            text: qsTr("RUN")
            anchors {
                left:button.right; leftMargin: 50;
                bottom:parent.bottom; bottomMargin: 15;
            }

            onClicked: {
                shaderManager.setCode(shaderCode.text);
                shader.updateFragment();
            }
        }

        Button {
            id: button4

            x: 801
            y: 950
            text: qsTr("NEW")
            anchors {
                left:button1.right; leftMargin: 50;
                bottom:parent.bottom; bottomMargin: 15;
            }

            onClicked : {
                shaderManager.code = "//NEWSHADER.FSH
void main()
{}"
                shader.updateFragment();
                shaderCode.text = shaderManager.code;
            }
        }
    }

    function singleClick(){
        print("Single click")
    }

    function dblClick(){
        if (rectangle1.visible === true) {
            rectangle1.visible = false;
            mainScreen.width = mainWindow.width;

            //            mainWindow.visibility = "FullScreen"
        } else {
            rectangle1.visible = true;
            mainScreen.width = mainWindow.width / 1.75;
            //            mainWindow.visibility = "Windowed"
        }
    }
}




/*##^## Designer {
    D{i:10;anchors_height:1000;anchors_width:555;anchors_x:639;anchors_y:0}D{i:11;anchors_height:1000;anchors_width:358;anchors_x:8;anchors_y:0}
D{i:8;anchors_y:-73}D{i:13;anchors_height:999}D{i:14;anchors_x:654;anchors_y:0}
}
 ##^##*/
