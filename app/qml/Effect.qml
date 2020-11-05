import QtQuick 2.0


ShaderEffect {
    id: shader
    function updateFragment(){
        fragmentShader = shaderManager.code;
    }

    width:parent.width
    height:parent.height
    property variant source
    property ListModel parameters: ListModel { }
    property bool divider
    property real dividerValue: 1
    property real targetWidth
    property real targetHeight
    property string fragmentShaderFilename
    property string vertexShaderFilename

    QtObject {
        id: d
        property string fragmentShaderCommon: "
            #ifdef GL_ES
                precision mediump float;
            #else
            #   define lowp
            #   define mediump
            #   define highp
            #endif // GL_ES
            void main() {
                gl_Position = transform * vertex;

                vertColor = color;
                newTCoord = texCoord;
                newTCoord.y = 1.0 - newTCoord.y;
                vertTexCoord = vec4(newTCoord, 1.0, 1.0);
            }

        "
    }

    // The following is a workaround for the fact that ShaderEffect
    // doesn't provide a way for shader programs to be read from a file,
    // rather than being inline in the QML file

    onFragmentShaderFilenameChanged:
    {
        fragmentShader = shaderManager.code;
    }

    onVertexShaderFilenameChanged:
    {
        vertexShader = fileReader.readFile(vertexShaderFilename);
    }

}
