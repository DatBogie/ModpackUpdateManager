#pragma once

#include <QObject>
#include "modpackmodel.h"
#include <QSettings>

class Backend : public QObject {
    Q_OBJECT

    public:
        QString prismPath;
        ModpackModel model;
        void findPrismPath();
        void addInstance(QString dir);
        void loadPrismInstances();
        Q_INVOKABLE void refreshPrismInstances();
        QSettings settings;
        Q_INVOKABLE void permRemoveInstance(int index);
        QStringList ignoredInstances;
        Q_INVOKABLE void clearIgnoreMemory();
        Q_INVOKABLE void importInstance(QString path);
    private:
        bool working = false;
};
