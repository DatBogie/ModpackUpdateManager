#!/bin/bash
onExit() {
	read -rp "Press Enter to exit..."
}

trap onExit EXIT

cd build &&
	cd -- */ &&
	echo "Renaming binary..." &&
	mv appsrc ModpackUpdateManager &&
	echo "Done!"
