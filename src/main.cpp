#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "backend.h"

#include <git2.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QCoreApplication::setOrganizationName("Dat Bogie");
    QCoreApplication::setOrganizationDomain("datbogie.org");
    QCoreApplication::setOrganizationName("Modpack Update Manager");

    git_libgit2_init();

    Backend backend;
    QVariant ignoredInstances = backend.settings.value("IgnoredModpacks");
    if (!ignoredInstances.isValid())
        backend.settings.setValue("IgnoredModpacks", backend.ignoredInstances);
    else
        backend.ignoredInstances = ignoredInstances.toStringList();
    QVariant autoUpdateInstances = backend.settings.value("AutoUpdatingModpacks");
    if (!autoUpdateInstances.isValid())
        backend.settings.setValue("AutoUpdatingModpacks", backend.autoUpdateInstances);
    else
        backend.autoUpdateInstances = autoUpdateInstances.toStringList();

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

    int exitCode = QGuiApplication::exec();

    git_libgit2_shutdown();

    return exitCode;
}
