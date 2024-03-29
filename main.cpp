#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "logicalitemsmap.h"
#include "logicalitemsparser.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

//    LogicalItemsParser parser;
//    parser.openFile("");

    qmlRegisterType<LogicalItemsMap>("Package.LogicalItemsMap", 1, 0, "LogicalItemsMap");
    qmlRegisterType<LogicalItemsParser>("Package.LogicalItemsParser", 1, 0, "LogicalItemsParser");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
