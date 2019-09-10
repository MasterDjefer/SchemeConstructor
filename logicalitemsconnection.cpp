#include "logicalitemsconnection.h"

void LogicalItemsConnection::printConnection() const
{
    qDebug() << out << ": " << value << ", " << in << ": " << pin;
}
