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

class LogicalItemsParser : public QObject
{
    Q_OBJECT

public:
    LogicalItemsParser();

    Q_INVOKABLE void openFile(const QVariant& fileName);

private:
    void cleanData(QString& data);
    void parse(QString& data);
    void parseItems();
    void printListItems();
    void convertData();
    QString openAttribute(const QString& attribute);
    QString closeAttribute(const QString& attribute);

private:
    QList<QMap<QString, QVariant> > mItemsList;
    QString mItemsData;

signals:
    void itemsParsed(const QVariant& data);
    void connectionsParsed(const QVariant& data);
};

#endif // LOGICALITEMSPARSER_H
