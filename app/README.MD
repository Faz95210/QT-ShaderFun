[![Qt version](https://img.shields.io/badge/Qt%20version-5.12.1-41cd52.svg?style=flat-square)](http://qt.io)
[![OpenCV version](https://img.shields.io/badge/OpenCV%20version-3.4.5-41cd52.svg?style=flat-square)](https://opencv.org)
[![C++ version](https://img.shields.io/badge/C++%20version-C++11-004482.svg?style=flat-square)](http://www.cplusplus.com/)
[![OpenCVtoQML](https://img.shields.io/badge/OpenCVtoQML%20version-1.0.0-41cd52.svg?style=flat-square)](http://gitlab.nconcepts.com.cn/NConcepts/Internal-Projects/opencvtoqml)


# Shader QML

This project uses the video output gotten by the lib [OpenCVtoQML](http://gitlab.nconcepts.com.cn/NConcepts/Internal-Projects/opencvtoqml/) and apply shaders on it with QML.

## Installation

To use this project simply follow the steps described in [OpenCVtoQML](http://gitlab.nconcepts.com.cn/NConcepts/Internal-Projects/opencvtoqml/)'s doc.

## How to use

Put some shaders inside an empty directory or create a directory where the program can create some shaders.  
Edit **includes/Config.h** so the `SHADER_DIRECTORY_PATH` match this directory's path.

![](./res/window.png)

1. Load previous shader
2. Current shader's name
3. Load next shader
4. Code of the current shader
5. Save Current shader in the file named on the first line.
6. Create a new shader (empty the code and load an empty shader)
7. Load current code


## Shaders

Here we'll explain how QML's shader work. There is 2 kinds of shaders : Fragment and Vertex. Here we'll talk about fragment shaders.

A fragment shader is a program running on the GPU that runs pixel by pixel.

### How to call them

In this project we've created a parent ShaderEffect

``` qml
ShaderEffect {

    function updateFragment(){ //Function called from main.qml to update the code.
        fragmentShader = shaderManager.code;
    }

    width:parent.width
    height:parent.height
    onFragmentShaderFilenameChanged:
    {
        fragmentShader = shaderManager.code;
    }
}
```

Which is called from the main this way : 
```qml
Effect {
    id:shader
    // Those parameters can be used in the shader
    property real grid: 2
    property real dividerValue: 1
    property real step_x: 0.015625
    property real step_y: step_x * 640 / 480
    property real qt_opacity: 0.5
    property variant source: mediaplayer
    property real blurSize : 0.3
    fragmentShaderFilename: shaderManager.shaders[0] //Either the code or 
}
```

### Examples

Here are a few examples showing some shader functionalities.

#### Warhol

The following shader take the picture and split it in four before changing the colors to give it a warhol style.

![](./res/warrhol.png)

##### Introduction
The first line `//split.fsh` is the name of the file. It isn't mandatory in GLSL but this program requires it to know where to save the file.

`//precision mediump float` defines the precision of the floats in the program. Defining a high precision can make the output prettier but the program slower, just like defining a low precision can make it faster but of lower quality. **This is doesn't exist in QML's GLSL**   

##### Global variable declaration
The program's variables are defined as follows : 
```glsl
uniform sampler2D source;
varying vec2 qt_TexCoord0;
uniform float dividerValue;
uniform lowp float qt_Opacity;
```

**Uniforms** Are variable defined in the QML. Here source is the video flux.
**Varyings** Are predifined variables the shader can access. Examples  : 

- gl_FragColor : Current fragment color. You can access it to either have a Vec3 with the RGB or BGR colors, or a Vec4 with the RGBA or BGRA colors. Modifying it will modify the color of the fragment.

- qt_TexCoord0 :  Fragment Coordinate. Vec2 with the XY position of the current fragment.

`uniform sampler2D source` is the source value declared in the QML : the camera output. 
##### Code beginning

Like in most languages GLSL starts with a main(). In QML's GLSL the main doesn't take parameters.

```glsl
void main(void)
{
    vec2 off = qt_TexCoord0;
    if (off.s > 0.5 && off.t > 0.5){ // BOTTOM RIGHT
        off.s -= 0.3;
        off.t -= 0.3;
        warholit(off, true, false, false);
    } else if (off.s < 0.5 && off.t > 0.5){ // BOTTOM LEFT
        off.s += 0.3;
        off.t -= 0.3;
        warholit(off, false, false, true);
    } else if (off.s > 0.5 && off.t < 0.5){ // TOP RIGHT
        off.s -= 0.3;
        off.t += 0.3;
        warholit(off, false, true, false);
    } else if (off.s < 0.5 && off.t < 0.5){ // TOP LEFT
        off.s += 0.3;
        off.t += 0.3;
        warholit(off, false, true, true);
    }
}
```

Here we simply assign the current fragment's position to a vec2 variable, pass it through ifs & elseifs to check where we are in the picture and then modify it to get the position of another pixel.  
_In GLSL positions and rgb.colors are variables between 0 and 1._

```glsl
void warholit(vec2 off, bool r, bool g, bool b) {
    vec4 orig = texture2D(source, off); // Get RGBA from the source with off as offset
    vec3 col = orig.rgb; // Get RGB From orig
    float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
    y = y < 0.3 ? 0.0 : (y < 0.6 ? 0.5 : 1.0);
    if (y == 0.5)
        col = vec3(r ? 0.8 : 0.0, g ? 0.8 : 0.0, b ? 0.8 : 0.0);
    else if (y == 1.0)
        col = vec3(r ? 0.9 : 0.0, g ? 0.9 : 0.0, b ? 0.9 : 0.0);
    else
        col = vec3(r ? 0.0 : 0.5, g ? 0.0 : 0.5,  b ? 0.0 : 0.5);
    if (off.x < dividerValue)
        gl_FragColor = qt_Opacity * vec4(col, 1.0);
    else
        gl_FragColor = qt_Opacity * orig;
}
```

Here `texture2D(source, off)` get the 2D texture from the source at the specified position. It returns the RGBA value.  
We need a Vec3 for the colors operations so we take the RGB from orig.  

This is a small operation giving the level of depth of the current pixel:

```glsl
    float y = 0.3 *col.r + 0.59 * col.g + 0.11 * col.b;
    y = y < 0.3 ? 0.0 : (y < 0.6 ? 0.5 : 1.0);
```

Depending of the level of depth gives a different color, to give a warhol effect : 

``` glsl
 if (y == 0.5)
    col = vec3(r ? 0.8 : 0.0, g ? 0.8 : 0.0, b ? 0.8 : 0.0);
else if (y == 1.0)
    col = vec3(r ? 0.9 : 0.0, g ? 0.9 : 0.0, b ? 0.9 : 0.0);
else
    col = vec3(r ? 0.0 : 0.5, g ? 0.0 : 0.5,  b ? 0.0 : 0.5);
```
_Side note : in glsl you can't compare integers (hence the if (y == 1.0) instead of if (y==1)_


Finally affect the new color to `gl_FragColor`

```GLSL
    if (off.x < dividerValue)
        gl_FragColor = qt_Opacity * vec4(col, 1.0);
    else
        gl_FragColor = qt_Opacity * orig;
```

#### Blueseeker

The following shader simply make a picture gray but enhances the blue colors.

![](./res/blueseeker.png)

##### Code

`vec3 col = texture2D(source, qt_TexCoord0).rgb` get the texture's rgb color. Convert the color in HLS.

```glsl
void rgb2hsl(vec3 rgb, out float h, out float s, float l)
{
    float maxval = max(rgb.r , max(rgb.g, rgb.b));
    float minval = min(rgb.r, min(rgb.g, rgb.b));
    float delta = maxval - minval;

    l = (minval + maxval) / 2.0;
    s = 0.0;
    if (l > 0.0 && l < 1.0)
        s = delta / (l < 0.5 ? 2.0 * l : 2.0 - 2.0 * l);
    h = 0.0;
    if (delta > 0.0)
    {
        if (rgb.r == maxval && rgb.g != maxval)
            h += (rgb.g - rgb.b ) / delta;
        if (rgb.g == maxval && rgb.b != maxval)
            h += 2.0  + (rgb.b - rgb.r) / delta;
        if (rgb.b == maxval && rgb.r != maxval)
            h += 4.0 + (rgb.r - rgb.g) / delta;
        h *= 60.0;
    }
}
```

If the HLS color is blue let the color intact, if not set it to gray.


#### Color Wheel

This shader show a color that changes at every frame. The current time is updated in the cpp and accessed in the shader via the qml.

```c++
//shaderManager.h
QElapsedTimer m_timer;


//shaderManager.cpp
m_timer.start();
QTimer *timer = new QTimer(this);
connect(timer,
        &QTimer::timeout,
        this,
        &ShaderManager::updateTimer);
timer->start(100);

void updateTimer(){
    m_u_time = (m_timer.elapsed());
    emit u_timeChanged(m_u_time);
}
```

```qml
Effect {
    id:shader
    property real u_time: shaderManager.u_time
    fragmentShaderFilename: ColorWheel.fsh
}
```

``` GLSL
// ColorWheel.fsh

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;

vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

void main() {
    vec3 color = vec3(0.0);

    float pct = abs(sin(u_time));

    // Mix uses pct (a value from 0-1) to
    // mix the two colors
    color = mix(colorA, colorB, pct);

    gl_FragColor = vec4(color,1.0);
}


```

## Good Read

[The book of shaders](https://thebookofshaders.com) is a website teaching most of what can be done on shaders but without camera.