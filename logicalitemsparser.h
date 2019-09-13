#ifndef LOGICALITEMSPARSER_H
#define LOGICALITEMSPARSER_H

#include <QObject>
#include <QFile>
#include <QDebug>
#include <QMap>

namespace FileAttributes
{
    const QString lif = "Lif";
    const QString items = "Items";
    const QString connections = "Connections";
}

namespace ItemAttributes
{
    const QString type = "type";
    const QString data = "data";
    const QString name = "name";
    const QString value = "value";
    const QString x = "x";
    const QString y = "y";
}

class LogicalItemsParser : public QObject
{
    Q_OBJECT

public:
    LogicalItemsParser();

    Q_INVOKABLE void openFile(const QVariant& fileName);
    Q_INVOKABLE void saveFile(const QVariant& items, const QVariant& connections);

private:
    void cleanData(QString& data);
    void parse(QString& data);
    void parseItems();
    void parseConnections();
    void printListItems();
    void printListConnections();
    void convertData();
    QString openAttribute(const QString& attribute);
    QString closeAttribute(const QString& attribute);

private:
    QList<QMap<QString, QVariant> > mItemsList;
    QList<QMap<QString, QVariant> > mConnectionsList;
    QString mItemsData;
    QString mConnectionsData;

    QString mOutputData;

signals:
    void itemsParsed(const QVariant& data);
    void connectionsParsed(const QVariant& data);
};

#endif // LOGICALITEMSPARSER_H
