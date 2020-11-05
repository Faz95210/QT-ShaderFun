#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <OpenCVtoQml.h>
#include <FaceDetection.h>

#include "includes/FileReader.h"
#include "includes/ShaderManager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<OpenCVtoQml>("fr.nconcepts", 1, 0, "OCVRenderer");
    qmlRegisterType<FaceDetection>("fr.nconcepts", 1, 0, "FaceDetection");
    FileReader fileReader;
    ShaderManager shaderManager;
    OpenCVtoQml openCVtoQml;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("opencvToQml", &openCVtoQml);
    engine.rootContext()->setContextProperty("fileReader", &fileReader);
    engine.rootContext()->setContextProperty("shaderManager", &shaderManager);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
