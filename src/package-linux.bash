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
	echo "Finding latest Qt location..." &&
	latestQtVersion=$(
		for dir in ~/Qt/*/; do
			name=${dir%/}
			name=${name##*/}
			[[ $name =~ ^[0-9]+(\.[0-9]+){1,3}$ ]] && echo "$name"
		done |
		awk -F. '{ printf "%010d.%010d.%010d %s\n", $1, $2, $3, $0 }' |
		sort |
		tail -n 1 |
		cut -d' ' -f2
	) &&
	buildSystem=$(
		for dir in ~/Qt/"$latestQtVersion"/*/; do
			name=${dir%/}
			name=${name##*/}
			[[ -x "$dir/bin/qmake" ]] && echo "$name"
			break
		done
	) &&
	echo "Using Qt $latestQtVersion with $buildSystem" &&
	echo "Copying .desktop file into $PWD..." &&
	cp "$REPO_ROOT_DIR/.ModpackUpdateManager.desktop" ./ModpackUpdateManager.desktop &&
	echo "Copying icon svg into $PWD..." &&
	cp "$REPO_ROOT_DIR/assets/icon.svg" ./icon.svg &&
	export QMAKE="$HOME/Qt/$latestQtVersion/$buildSystem/bin/qmake" &&
	export QML_SOURCES_PATHS="$REPO_ROOT_DIR" &&
	echo "Bundling Qt/QML library files via linuxdeploy/linuxdeploy-plugin-qt..." &&
	linuxdeploy --appdir AppDir -d ModpackUpdateManager.desktop -e ModpackUpdateManager -i icon.svg --plugin qt --output appimage &&
	echo "Done!" || echo "Failed!"
