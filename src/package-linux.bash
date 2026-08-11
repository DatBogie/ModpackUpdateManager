#!/bin/bash
onExit() {
	read -rp "Press Enter to exit..."
}

trap onExit EXIT

echo "CDing into build directory..." && \
cd build && \
cd -- */ && \
echo "Renaming binary..." && \
mv appsrc ModpackUpdateManager && \
echo "Done!"
