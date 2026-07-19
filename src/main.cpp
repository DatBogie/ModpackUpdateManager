#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QDebug>

#include "modpackmodel.h"

QString prismPath;
ModpackModel model;

void Update() {
    QDirIterator iter(prismPath+"/instances");
    while (iter.hasNext()) {
        QString dir = iter.next();
        if (dir.endsWith(".") || dir.endsWith("..") || !QDir(dir).exists()) continue;
        QString name;
        QString thumbKey;
        QString thumbParentPath;
        bool isCompatible = false;
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
        if (QDir(prismPath+"/icons/"+thumbKey).exists())
            thumbParentPath = prismPath+"/icons/";
        else {
            thumbKey = "icon.png";
            thumbParentPath = dir+"/minecraft/";
        }
        isCompatible = QFile(dir+"/.modpackupdatemanager.json").exists();
        model.addInstance({ name, thumbKey, thumbParentPath, isCompatible });
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    #ifdef Q_OS_LINUX
        prismPath = QDir::homePath()+"/.local/share/PrismLauncher";
        if (!QDir(prismPath).exists())
            prismPath = QDir::homePath()+"/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher";
    #elif defined(Q_OS_WIN)
        prismPath = QDir::homePath()+"/AppData/Roaming/PrismLauncher";
    #elif defined(Q_OS_MACOS)
        prismPath = QDir::homePath()+"/Library/Application Support/PrismLauncher";
    #endif

    Update(); // Expose to QML

    engine.rootContext()->setContextProperty("modpackModel",&model);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("src", "Main");

    return QGuiApplication::exec();
}
