#!/bin/bash
onExit() {
	read -rp "Press Enter to exit..."
}

trap onExit EXIT

cd build &&
	cd -- */ &&
	mkdir dist &&
	echo "Copying .app to $PWD/dist..." &&
	cp -r appsrc.app dist/ModpackUpdateManager.app &&
	cd dist &&
	echo "Renaming binary..." &&
	mv ModpackUpdateManager.app/Contents/MacOS/appsrc ModpackUpdateManager.app/Contents/MacOS/ModpackUpdateManager &&
	echo "Updating .app's Plist values via /usr/libexec/PlistBuddy..." &&
	/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable ModpackUpdateManager" ModpackUpdateManager.app/Contents/Info.plist &&
	/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier org.datbogie.ModpackUpdateManager" ModpackUpdateManager.app/Contents/Info.plist &&
	/usr/libexec/PlistBuddy -c "Set :CFBundleName Modpack Update Manager" ModpackUpdateManager.app/Contents/Info.plist &&
	echo "Finding latest Qt installation..." &&
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
	echo "Using Qt $latestQtVersion..." &&
	echo "Copying Qt/QML library files via macdeployqt..." &&
	"$HOME/Qt/$latestQtVersion/macos/bin/macdeployqt" ModpackUpdateManager.app "-qmldir=$HOME/Qt/$latestQtVersion/macos/qml" &&
	echo "Done!"
