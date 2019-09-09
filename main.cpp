#include <QGuiApplication>
#include <QQmlApplicationEngine>

//#include <QObject>
//class A : public QObject
//{
//    Q_OBJECT

//public:
//    A(){}

//public slots:
//    void onGetConnection(const QVariant& val)
//    {

//    }
//};

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

//    A a;

    return app.exec();
}
