#!/bin/bash
onExit() {
	read -rp "Press Enter to exit..."
}

trap onExit EXIT

REPO_ROOT_DIR="$PWD" &&
	cd build &&
	cd -- */ &&
	mkdir dist &&
	echo "Copying binary to $PWD/dist..." &&
	cp appsrc dist/ModpackUpdateManager &&
	cd dist &&
	printf "[Desktop Entry]\nType=Application\nName=Modpack Update Manager\nExec=ModpackUpdateManager\nCategories=Utility;" > ../ModpackUpdateManager.desktop &&
	export QML_SOURCES_PATHS="$REPO_ROOT_DIR" &&
	echo "Bundling Qt/QML library files via linuxdeploy/linuxdeploy-plugin-qt..." &&
	linuxdeploy --appdir AppDir -e ModpackUpdateManager -d ../ModpackUpdateManager.desktop --plugin qt --output appimage &&
	echo "Done!"
