#!/bin/bash
onExit() {
	read -rp "Press Enter to exit..."
}

trap onExit EXIT

echo "CDing into build directory..." &&
	cd build &&
	cd -- */ &&
	echo "Renaming .app..." &&
	mv appsrc.app ModpackUpdateManager.app &&
	echo "Renaming binary..." &&
	mv ModpackUpdateManager.app/Contents/MacOS/appsrc ModpackUpdateManager.app/Contents/MacOS/ModpackUpdateManager &&
	echo "Updating .app Plist values via /usr/libexec/PlistBuddy..." &&
	/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable ModpackUpdateManager" ModpackUpdateManager.app/Contents/Info.plist &&
	/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier org.datbogie.ModpackUpdateManager" ModpackUpdateManager.app/Contents/Info.plist &&
	/usr/libexec/PlistBuddy -c "Set :CFBundleName Modpack Update Manager" ModpackUpdateManager.app/Contents/Info.plist &&
	echo "Done!"
