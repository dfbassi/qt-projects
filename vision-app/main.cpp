#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "pixmapcontainer.h"
#include "pixmapimage.h"

#include "opencvhandler.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

//handles the conversion process from opencv in c++ to the qml level
    qmlRegisterType<PixmapContainer>("io.qt.forum", 1, 0, "PixmapContainer");
    qmlRegisterType<PixmapImage>("io.qt.forum", 1, 0, "PixmapImage");

    QQmlApplicationEngine qmlEngine;

    OpenCvHandler handler;
    qmlEngine.rootContext()->setContextProperty("opencv_handler", &handler);

    qmlEngine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (qmlEngine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
