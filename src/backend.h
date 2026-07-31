#pragma once

#include <QObject>
#include <QSettings>
#include <QFile>
#include <QDir>

#include "modpackmodel.h"
#include "modpackcheckupdateresponse.h"
#include "modpackupdateresponse.h"

class Backend : public QObject {
    Q_OBJECT

    public:
        QString prismPath;
        ModpackModel model;
        void findPrismPath();
        QString extractZip(QString path);
        ModpackCheckUpdateResponse checkUpdate(ModpackInstance mi);
        Q_INVOKABLE QVariantMap qmlCheckUpdate(QVariantList mi);
        ModpackUpdateResponse updateInstance(ModpackInstance mi);
        Q_INVOKABLE QVariantMap qmlUpdateInstance(QVariantList mi);
        QJsonObject readJson(QFile *file);
        bool writeJson(QFile *file, QJsonObject data);
        ModpackInstance addInstance(QString dir);
        void loadPrismInstances();
        Q_INVOKABLE void refreshPrismInstances();
        QSettings settings;
        Q_INVOKABLE void permRemoveInstance(int index);
        QStringList ignoredInstances;
        QStringList autoUpdateInstances;
        Q_INVOKABLE bool setupPack(QVariantMap mi);
        Q_INVOKABLE void clearIgnoreMemory();
        Q_INVOKABLE void importInstance(QString path);
        Q_INVOKABLE void setEnabledProperty(int index, bool value, QString packName);
        Q_INVOKABLE void setCompatibleProperty(int index, bool value);
        Q_INVOKABLE void setUpdateUrlProperty(int index, QString url);
        Q_INVOKABLE void setPendingUpdateProperty(int index, QVariantMap updateResponse);
        Q_INVOKABLE void setCurrentVersionIdProperty(int index, QString versionId);
        Q_INVOKABLE void setCurrentVersionTypeProperty(int index, QString versionType);
        Q_INVOKABLE QVariantMap recordModpackSnapshot(QVariantMap mi);
        Q_INVOKABLE QString changelogToString(QVariantList changelog);
        Q_INVOKABLE QVariantList genChangelog(QVariantMap mi, QVariantMap initialSnapshot);
        Q_INVOKABLE bool createNewVersion(QVariantMap mi, QVariantMap initialSnapshot, QString versionId, QString versionType, QString versionName, QString versionDesc);
        Q_INVOKABLE QString getGitCachePath();
        Q_INVOKABLE void openGitCache();
    private:
        bool working = false;
        QVariantMap ModpackResponseToQVariantMap(ModpackResponseBase response);
        ModpackUpdateResponse ModpackCheckUpdateResponseToModpackUpdateResponse(ModpackCheckUpdateResponse response, bool success);
        QString getRepoPath(ModpackInstance mi);
        bool areFilesDuplicates(QFile &a, QFile &b);
        ModpackInstance QVariantMapToModpackInstance(QVariantMap mi);
        QVariantMap handleRecordIterFile(QDir instDir, QFileInfo fileInfo);
};
