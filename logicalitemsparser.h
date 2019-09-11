#ifndef LOGICALITEMSPARSER_H
#define LOGICALITEMSPARSER_H

#include <QFile>
#include <QDebug>
#include <QMap>

class LogicalItemsParser
{
private:
    QString mData;
    QList<QMap<QString, QVariant> > mList;

public:
    LogicalItemsParser();

    void openFile(const QString& fileName);
    void cleanData();
    void parse();
    void printListItems();
};

#endif // LOGICALITEMSPARSER_H
