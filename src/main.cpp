#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "backend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QCoreApplication::setOrganizationName("Dat Bogie");
    QCoreApplication::setOrganizationDomain("datbogie.org");
    QCoreApplication::setOrganizationName("Modpack Update Manager");

    Backend backend;
    QVariant ignoredInstances = backend.settings.value("IgnoredModpacks");
    if (!ignoredInstances.isValid())
        backend.settings.setValue("IgnoredModpacks", backend.ignoredInstances);
    else
        backend.ignoredInstances = ignoredInstances.toStringList();

    backend.model.addInstance({"Homer Modpack", "giphy.gif", "/home/dat-bogie/Downloads/", true, false, true});
    backend.model.addInstance({"External Modpack", "album_2025-08-04_00-20-32.gif", "/home/dat-bogie/Pictures/", false, false});

    backend.findPrismPath();
    backend.loadPrismInstances();

    engine.rootContext()->setContextProperty("modpackModel",&backend.model);
    engine.rootContext()->setContextProperty("backend",&backend);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("src", "Main");

    return QGuiApplication::exec();
}
