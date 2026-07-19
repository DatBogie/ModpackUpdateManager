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
        void loadPrismInstances();
        Q_INVOKABLE void refreshPrismInstances();
        QSettings settings;
        Q_INVOKABLE void permRemoveInstance(int index);
        QStringList ignoredInstances;
        Q_INVOKABLE void clearIgnoreMemory();
    private:
        bool working = false;
};
