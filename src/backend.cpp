#include "backend.h"
#include <QDirIterator>
#include <QDir>
#include <QFile>
#include <QList>
#include <QDebug>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QProcess>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QCryptographicHash>

#include "modpackresponsebase.h"
#include "modpackcheckupdateresponse.h"
#include "modpackupdateresponse.h"

#include <quazip/quazip.h>
#include <quazip/quazipfile.h>
#include <git2.h>

void Backend::findPrismPath() {
    #ifdef Q_OS_LINUX
        prismPath = QDir::homePath()+"/.local/share/PrismLauncher";
        if (!QDir(prismPath).exists())
            prismPath = QDir::homePath()+"/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher";
    #elif defined(Q_OS_WIN)
        prismPath = QDir::homePath()+"/AppData/Roaming/PrismLauncher";
    #elif defined(Q_OS_MACOS)
        prismPath = QDir::homePath()+"/Library/Application Support/PrismLauncher";
    #endif
}

QString Backend::extractZip(QString path) {
    QFileInfo info(path);
    if (info.suffix().compare("zip", Qt::CaseInsensitive) != 0) return "";
    QuaZip zip(path);
    if (!zip.open(QuaZip::mdUnzip)) {
        qDebug() << zip.getZipName();
        qDebug() << zip.getZipError();
        return "";
    }
    QString dest = prismPath+"/instances/"+info.baseName();
    QDir dir(dest);
    if (dir.exists()) {
        int i=0;
        while (dir.exists() && i<100) {
            i++;
            dir = QDir(dest+" (" + QString::number(i) + ")");
        }
        if (dir.exists()) return "";
    }
    dir.mkpath(".");
    for (bool more = zip.goToFirstFile(); more; more = zip.goToNextFile()) {
        QString fName = zip.getCurrentFileName();
        QString nPath = dest+"/"+fName;
        QuaZipFile zipFile(&zip);
        if (!zipFile.open(QIODevice::ReadOnly)) continue;
        QFile nFile(nPath);
        QDir().mkpath(QFileInfo(nPath).path());
        if (nFile.open(QIODevice::WriteOnly)) {
            nFile.write(zipFile.readAll());
            nFile.close();
        }
        zipFile.close();
    }
    zip.close();
    return dir.path();
}

bool Backend::writeJson(QFile *file, QJsonObject data) {
    QFileInfo fileInfo = QFileInfo(*file);
    if (!file->exists()) {
        qWarning() << "File" << fileInfo.absoluteFilePath() << "doesn't exist!";
        return false;
    }
    QJsonDocument doc(data);
    if (!file->open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to open" << fileInfo.absoluteFilePath() << "! Error:" << file->errorString();
        return false;
    }
    bool success = true;
    if (file->write(doc.toJson(QJsonDocument::Indented)) == -1) {
        success = false;
        qWarning() << "Failed to write to" << fileInfo.absoluteFilePath() << "! Error:" << file->errorString();
    }
    file->close();
    return success;
}

QJsonObject Backend::readJson(QFile *file) {
    if (!file->exists()) return {};
    if (file->open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray data = file->readAll();
        file->close();
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(data, &error);
        if (error.error == QJsonParseError::NoError) {
            return doc.object();
        } else {
            qWarning() << "Json parse error whilst loading '" << file->fileName() << "/.modpackupdatemanager.json': " << error.errorString();
        }
    }
    file->close();
    return {};
}

QString Backend::getRepoPath(ModpackInstance mi) {
    return QDir::cleanPath(QStandardPaths::writableLocation(QStandardPaths::StandardLocation::AppLocalDataLocation)+"/../git.cache/"+mi.name);
}

ModpackCheckUpdateResponse Backend::checkUpdate(ModpackInstance mi) {
    if (!mi.updateUrl.startsWith("https://github.com/")) {
        qWarning() << mi.updateUrl << "is not a valid GitHub URL!";
        return {};
    }
    QDir gitCache(getRepoPath(mi));
    qDebug() << "Repo path:" << gitCache.absolutePath();
    git_repository *repo = nullptr;
    if (!gitCache.exists()) {
        QDir().mkpath(gitCache.absolutePath());
        git_clone_options opts = GIT_CLONE_OPTIONS_INIT;
        opts.checkout_branch = "main";
        int error = git_clone(&repo, mi.updateUrl.toUtf8().constData(), gitCache.absolutePath().toUtf8().constData(), &opts);
        if (error != 0) {
            const git_error *e = git_error_last();
            qWarning() << "Error whilst cloning" << mi.updateUrl << ":" << (e? e->message : "Unknown libgit2 error");
        }
        git_repository_free(repo);
        if (error != 0) return {};
    } else {
        if (git_repository_open(&repo, gitCache.absolutePath().toUtf8().constData()) == 0) {
            git_remote *remote = nullptr;
            if (git_remote_lookup(&remote, repo, "origin") == 0) {
                git_fetch_options fetchOpts = GIT_FETCH_OPTIONS_INIT;
                if (git_remote_fetch(remote, nullptr, &fetchOpts, "Update local repo") == 0) {
                    git_oid localOid;
                    git_oid remoteOid;
                    git_reference *localRef = nullptr;
                    git_reference *remoteRef = nullptr;
                    git_repository_head(&localRef, repo);
                    git_reference_name_to_id(&localOid, repo, git_reference_name(localRef));
                    git_reference_lookup(&remoteRef, repo, "refs/remotes/origin/main");
                    git_reference_name_to_id(&remoteOid, repo, git_reference_name(remoteRef));
                    bool upToDate = git_oid_equal(&localOid, &remoteOid);
                    git_reference_free(localRef);
                    git_reference_free(remoteRef);
                    if (!upToDate) {
                        git_object *target = nullptr;
                        if (git_revparse_single(&target, repo, "origin/main") == 0) {
                            if (git_reset(repo, target, GIT_RESET_HARD, nullptr) == 0) {
                                qDebug() << "Successfully updated repo" << gitCache.dirName() << "!";
                            } else {
                                const git_error *e = git_error_last();
                                qWarning() << "Failed to hard-reset repo" << gitCache.dirName() << "! Error:" << (e? e->message : "Unknown libgit2 error");
                            }
                        } else {
                            const git_error *e = git_error_last();
                            qWarning() << "Failed to find origin/main for repo" << gitCache.dirName() << "! Repo is likely setup incorrectly. Error:" << (e? e->message : "Unknown libgit2 error");
                        }
                        git_object_free(target);
                    } else {
                        qDebug() << "Repo" << gitCache.dirName() << "is already up-to-date!";
                    }
                } else {
                    const git_error *e = git_error_last();
                    qWarning() << "Failed to fetch repo" << gitCache.dirName() << "! Error:" << (e? e->message : "Unknown libgit2 error");
                }
            } else {
                const git_error *e = git_error_last();
                qWarning() << "Failed to lookup repo" << gitCache.dirName() << "! Error:" << (e? e->message : "Unknown libgit2 error");
            }
            git_remote_free(remote);
        } else {
            const git_error *e = git_error_last();
            qWarning() << "Failed to open repo" << gitCache.dirName() << "! Error:" << (e? e->message : "Unknown libgit2 error");
        }
        git_repository_free(repo);
    }
    QFile updateRepoJson(gitCache.absolutePath()+"/modpackupdatemanager.json");
    QJsonObject obj = readJson(&updateRepoJson);
    QJsonValueRef refVersions = obj["Versions"];
    if (!refVersions.isArray()) {
        qWarning() << "Property \"Versions\" is not defined properly in" << updateRepoJson.fileName();
        return {};
    }
    QJsonArray versions = refVersions.toArray();
    for (int i=versions.size()-1; i>=0; i--) {
        if (!versions[i].isObject()) continue;
        QJsonObject ver = versions[i].toObject();
        if (ver["Id"].isString() && ver["Id"].toString() == mi.currentVersionId) {
            qDebug() << mi.name << "is already up-to-date (no newer versions found)!";
            return {};
        }
        if (ver["Type"] != mi.currentVersionType || !ver["Id"].isString()) continue;
        return { ver["Id"].toString(), ver["Type"].toString(), ver["Name"].toString(), ver["Description"].toString(), ver["Changelog"].toArray().toVariantList(), true };
    }
    qDebug() << mi.name << "is already up-to-date (no other versions found)!";
    return {};
}

QVariantMap Backend::qmlCheckUpdate(QVariantList mi) {
    ModpackInstance inst = { mi[0].toString(), mi[1].toString(), mi[2].toString(), mi[3].toBool(), mi[4].toBool(), mi[5].toBool(), mi[6].toString(), mi[7].toString(), mi[8].toString(), mi[9].toString() };
    ModpackCheckUpdateResponse response = checkUpdate(inst);
    QVariantMap ret;
    ret["updateId"] = response.updateId;
    ret["updateType"] = response.updateType;
    ret["updateName"] = response.updateName;
    ret["updateDesc"] = response.updateDesc;
    ret["changelog"] = response.changelog;
    ret["hasUpdate"] = response.hasUpdate;
    return ret;
}

QVariantMap Backend::ModpackResponseToQVariantMap(ModpackResponseBase response) {
    QVariantMap ret;
    ret["updateId"] = response.updateId;
    ret["updateType"] = response.updateType;
    ret["updateName"] = response.updateName;
    ret["updateDesc"] = response.updateDesc;
    ret["changelog"] = response.changelog;
    return ret;
}

ModpackUpdateResponse Backend::ModpackCheckUpdateResponseToModpackUpdateResponse(ModpackCheckUpdateResponse response, bool success) {
    return { response.updateId, response.updateType, response.updateName, response.updateDesc, response.changelog, success };
}

bool Backend::areFilesDuplicates(QFile &a, QFile &b) {
    QFileInfo ia(a);
    QFileInfo ib(b);
    if (ia.size() != ib.size()) return false;
    if (!a.open(QIODevice::ReadOnly) || !b.open(QIODevice::ReadOnly)) return false;
    QCryptographicHash ha(QCryptographicHash::Sha256);
    QCryptographicHash hb(QCryptographicHash::Sha256);
    if (!ha.addData(&a) || !hb.addData(&b)) {
        a.close();
        b.close();
        return false;
    }
    bool result = ha.result() == hb.result();
    a.close();
    b.close();
    return result;
}

ModpackUpdateResponse Backend::updateInstance(ModpackInstance mi) {
    if (!mi.pendingUpdate.hasUpdate) return {};
    QVariantList *changelog = &mi.pendingUpdate.changelog;
    QDir updateDir(getRepoPath(mi)+"/versions/"+mi.pendingUpdate.updateId);
    QDir packDir(mi.instancePath+"/minecraft");
    if (!packDir.exists()) packDir = QDir(mi.instancePath+"/.minecraft");
    bool success = false;
    for (int i=0; i<changelog->size(); i++) {
        QVariantMap change = changelog->at(i).toMap();
        QFile newMod(updateDir.absolutePath()+"/"+change["Path"].toString());
        QFile oldMod(packDir.absolutePath()+"/"+change["Path"].toString());
        QFileInfo newModInfo(newMod);
        QFileInfo oldModInfo(oldMod);
        if (change["ChangeType"].toString() != "-") {
            // Adding
            if (!newMod.exists()) {
                qWarning() << "Mod" << newModInfo.fileName() << "doesn't exist in" << newModInfo.absoluteDir().absolutePath() << "!";
                break;
            }
            if (oldMod.exists()) {
                qDebug() << "Note:" << oldMod.fileName() << "exists!";
                if (areFilesDuplicates(newMod, oldMod)) {
                    qDebug() << "Mod" << newModInfo.fileName() << "already exists in" << oldModInfo.absoluteDir().absolutePath() << "! Skipping...";
                    continue;
                }
                if (!oldMod.remove()) {
                    qWarning() << "Failed to remove mod" << newModInfo.fileName() << "! Error:" << oldMod.errorString();
                    break;
                }
            }
            if (!newMod.copy(oldMod.fileName())) {
                qWarning() << "Failed to copy mod" << newModInfo.fileName() << "! Error:" << newMod.errorString();
                break;
            }
            qDebug() << "Successfully copied mod" << newModInfo.fileName() << "!";
            continue;
        }
        // Removing
        if (oldMod.exists()) {
            qDebug() << "Removing mod" << newModInfo.fileName() << "...";
            if (!oldMod.remove())
                qWarning() << "Failed to remove mod" << newModInfo.fileName() << "! Error:" << oldMod.errorString();
            break;
        }
        qDebug() << "Nothing to remove; mod" << newModInfo.fileName() << "doesn't exist in" << oldModInfo.absoluteDir().absolutePath() << "!";
    }
    ModpackUpdateResponse updateResponse = ModpackCheckUpdateResponseToModpackUpdateResponse(mi.pendingUpdate, true);
    if (updateResponse.success) {
        QFile updateDef(mi.instancePath+"/.modpackupdatemanager.json");
        QJsonObject data = readJson(&updateDef);
        if (data.isEmpty()) data["UpdateUrl"] = mi.updateUrl;
        data["VersionId"] = mi.pendingUpdate.updateId;
        data["VersionType"] = mi.pendingUpdate.updateType;
        writeJson(&updateDef, data);
    }
    return updateResponse;
}

QVariantMap Backend::qmlUpdateInstance(QVariantList mi) {
    ModpackInstance inst = { mi[0].toString(), mi[1].toString(), mi[2].toString(), mi[3].toBool(), mi[4].toBool(), mi[5].toBool(), mi[6].toString(), mi[7].toString(), mi[8].toString(), mi[9].toString(), model.QVariantMapToModpackCheckUpdateResponse(mi[10].toMap()) };
    ModpackUpdateResponse response = updateInstance(inst);
    QVariantMap ret = ModpackResponseToQVariantMap(response);
    ret["success"] = response.success;
    return ret;
}

ModpackInstance Backend::addInstance(QString dir) {
    QString name;
    QString thumbKey;
    QString thumbParentPath;
    QFile cfg = QFile(dir+"/instance.cfg");
    if (cfg.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&cfg);
        while (!in.atEnd()) {
            QString ln = in.readLine();
            QStringList parts = ln.split('=');
            if (parts.size() == 2) {
                QString key = parts[0].trimmed();
                QString val = parts[1].trimmed();
                if (key == "name")
                    name = val;
                else if (key == "iconKey")
                    thumbKey = val;
            }
        }
    }
    cfg.close();
    if (ignoredInstances.contains(name)) return {};
    QVector<QString> imageTypes = {"",".png",".jpg",".jpeg",".webp",".gif"};
    bool thumbExists = false;
    for (QString &ext : imageTypes) {
        thumbExists = QFile(prismPath+"/icons/"+thumbKey+ext).exists();
        if (thumbExists) {
            thumbKey += ext;
            break;
        }
    }
    if (thumbExists)
        thumbParentPath = prismPath+"/icons/";
    else {
        thumbKey = "icon.png";
        thumbParentPath = dir+(QDir(dir+"/minecraft").exists()? "/minecraft/" : "/.minecraft/");
    }
    QFile updateDef(dir+"/.modpackupdatemanager.json");
    bool isCompatible = false;
    QString updateUrl;
    QString currentVersionId;
    QString currentVersionType;
    QJsonObject obj = readJson(&updateDef);
    if (!obj.isEmpty()) {
        isCompatible = true;
        updateUrl = obj["UpdateUrl"].toString();
        currentVersionId = obj["VersionId"].toString();
        currentVersionType = obj["VersionType"].toString();
    }
    ModpackCheckUpdateResponse updResponse;
    bool packEnabled = isCompatible && autoUpdateInstances.contains(name);
    if (isCompatible) {
        updResponse = checkUpdate({ name, thumbKey, thumbParentPath, isCompatible, true, isCompatible, updateUrl, currentVersionId, currentVersionType });
    }
    ModpackInstance mi = { name, thumbKey, thumbParentPath, packEnabled, true, isCompatible, updateUrl, currentVersionId, currentVersionType, dir, updResponse };
    if (packEnabled && updResponse.hasUpdate) {
        ModpackUpdateResponse response = updateInstance(mi);
        if (response.success) {
            mi = { name, thumbKey, thumbParentPath, packEnabled, true, isCompatible, updateUrl, response.updateId, response.updateType, dir, {} };
        }
    }
    model.addInstance(mi);
    return mi;
}

void Backend::loadPrismInstances() {
    QDirIterator iter(prismPath+"/instances");
    while (iter.hasNext()) {
        QString dir = iter.next();
        if (dir.endsWith(".") || dir.endsWith("..") || !QDir(dir).exists() || (!QDir(dir+"/minecraft").exists() && !QDir(dir+"/.minecraft").exists()) || !QFile(dir+"/instance.cfg").exists()) continue;
        addInstance(dir);
    }
}

void Backend::refreshPrismInstances() {
    if (working) return;
    working = true;
    int i = model.findNextPrismIndex();
    while (i != -1) {
        model.removeInstance(i);
        i = model.findNextPrismIndex();
    }
    Backend::loadPrismInstances();
    working = false;
}

void Backend::permRemoveInstance(int index) {
    ModpackInstance mi = model.instanceAt(index);
    if (mi.fromPrism) {
        ignoredInstances << mi.name;
        settings.setValue("IgnoredModpacks", ignoredInstances);
    }
    model.removeInstance(index);
}

void Backend::clearIgnoreMemory() {
    ignoredInstances.clear();
    settings.setValue("IgnoredModpacks", ignoredInstances);
}

void Backend::importInstance(QString path) {
    path = QUrl(path).toLocalFile();
    QString result = extractZip(path);
    if (result != "") addInstance(result);
}

bool Backend::setupPack(QVariantMap mi) {
    ModpackInstance instance = { mi["name"].toString(), mi["thumbnailKey"].toString(), mi["thumbnailParentPath"].toString(), mi["packEnabled"].toBool(), mi["fromPrism"].toBool(), mi["isCompatible"].toBool(), mi["updateUrl"].toString(), mi["currentVersionId"].toString(), mi["currentVersionType"].toString(), mi["instancePath"].toString() };
    QFile compat(instance.instancePath+"/.modpackupdatemanager.json");
    QJsonObject data = QJsonObject::fromVariantMap({ { "UpdateUrl", instance.updateUrl }, { "VersionId", "1.0.0" }, { "VersionType", "release" } });
    if (compat.exists()) {
        qWarning() << "The modpack " << instance.name << "is already compatible!";
        return false;
    }
    if (!compat.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open file" << compat.fileName() << "! Error:" << compat.errorString();
        return false;
    }
    compat.close();
    bool success = writeJson(&compat, data);
    if (success) refreshPrismInstances();
    return success;
}

void Backend::setEnabledProperty(int index, bool value, QString packName) {
    if (!model.setRoleProperty(index, model.EnabledRole, QVariant(value))) return;
    if (value)
        autoUpdateInstances << packName;
    else
        autoUpdateInstances.removeAll(packName);
    settings.setValue("AutoUpdatingModpacks", autoUpdateInstances);
}

void Backend::setCompatibleProperty(int index, bool value) {
    model.setRoleProperty(index, model.IsCompatibleRole, QVariant(value));
}

void Backend::setUpdateUrlProperty(int index, QString url) {
    model.setRoleProperty(index, model.UpdateUrlRole, url);
}

void Backend::setPendingUpdateProperty(int index, QVariantMap updateResponse) {
    model.setRoleProperty(index, model.PendingUpdateRole, QVariant(updateResponse));
}

void Backend::setCurrentVersionIdProperty(int index, QString versionId) {
    model.setRoleProperty(index, model.CurrentVersionIdRole, QVariant(versionId));
}

void Backend::setCurrentVersionTypeProperty(int index, QString versionType) {
    model.setRoleProperty(index, model.CurrentVersionTypeRole, QVariant(versionType));
}
