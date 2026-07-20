#include "backend.h"
#include <QDirIterator>
#include <QDir>
#include <QFile>
#include <QList>
#include <QDebug>
#include <QUrl>

#include <quazip/quazip.h>
#include <quazip/quazipfile.h>

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

void Backend::addInstance(QString dir) {
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
    if (ignoredInstances.contains(name)) return;
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
        thumbParentPath = dir+"/minecraft/";
    }
    bool isCompatible = QFile(dir+"/.modpackupdatemanager.json").exists();
    model.addInstance({ name, thumbKey, thumbParentPath, isCompatible, true, isCompatible });
}

void Backend::loadPrismInstances() {
    QDirIterator iter(prismPath+"/instances");
    while (iter.hasNext()) {
        QString dir = iter.next();
        if (dir.endsWith(".") || dir.endsWith("..") || !QDir(dir).exists()) continue;
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
    QFileInfo info(path);
    if (info.suffix().compare("zip", Qt::CaseInsensitive) != 0) return;
    QuaZip zip(path);
    if (!zip.open(QuaZip::mdUnzip)) {
        qDebug() << zip.getZipName();
        qDebug() << zip.getZipError();
        return;
    }
    QString dest = prismPath+"/instances/"+info.baseName();
    QDir dir(dest);
    if (dir.exists()) {
        int i=0;
        while (dir.exists() && i<100) {
            i++;
            dir = QDir(dest+" (" + QString::number(i) + ")");
        }
        if (dir.exists()) return;
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
    addInstance(dir.path());
}
