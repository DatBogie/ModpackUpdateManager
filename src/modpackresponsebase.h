#pragma once

#include <QString>
#include <QVariantList>

struct ModpackResponseBase {
    QString updateId;
    QString updateType;
    QString updateName;
    QString updateDesc;
    QVariantList changelog;
};
