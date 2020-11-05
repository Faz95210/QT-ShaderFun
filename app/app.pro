QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

OPEN_CV_PATH = /usr/local/Cellar/opencv
OPEN_CV_VERSION = 4.4
OPEN_CV_MINOR = 0_2
OPEN_CV_FULL_PATH = $${OPEN_CV_PATH}/$${OPEN_CV_VERSION}.$${OPEN_CV_MINOR}
CV_2_QML_LIB_PATH = '../build/lib'
CV_2_QML_HEADERS_PATH = '../lib/includes/'

SOURCES += \
        src/FileReader.cpp \
        src/ShaderManager.cpp \
        main.cpp

HEADERS += \
    includes/Config.h \
    includes/FileReader.h \
    includes/ShaderManager.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += $${OPEN_CV_FULL_PATH}/include/opencv4/
INCLUDEPATH += $${OPEN_CV_FULL_PATH}/lib/


LIBS += \
    -L$${OPEN_CV_FULL_PATH}/lib \
    -lopencv_bgsegm.$${OPEN_CV_VERSION} -lopencv_shape -lopencv_video \
    -lopencv_highgui -lopencv_videoio -lopencv_flann \
    -lopencv_xobjdetect -lopencv_imgcodecs -lopencv_objdetect \
    -lopencv_xphoto -lopencv_imgproc -lopencv_core \
    -lopencv_face

PRE_TARGETDEPS  += $${CV_2_QML_LIB_PATH}/libOpenCVtoQml.1.1.0.dylib
LIBS            += -L$${CV_2_QML_LIB_PATH} -lOpenCVtoQml.1.1.0
INCLUDEPATH     += $${CV_2_QML_HEADERS_PATH}
DEPENDPATH      += $${CV_2_QML_LIB_PATH}/libOpenCVtoQml.1.1.0.dylib

DISTFILES += \
    timeColor.fsh
