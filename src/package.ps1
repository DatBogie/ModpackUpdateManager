cd .\build
cd (ls -Directory)

mkdir dist

Write-Host "Copying EXE to $PWD\dist..."
cp .\appsrc.exe .\dist
Write-Host "Copying DLLs to $PWD\dist..."
cp .\*.dll .\dist
cp .\external\quazip\quazip\bz2.dll .\dist
cp .\external\quazip\quazip\quazip1-qt6.dll .\dist

cd .\dist

Write-Host "Finding latest Qt installation..."
$latestQtVersion = ls -Directory C:\Qt | where { $_.Name -match '^\d+(\.\d+){1,3}$' } | sort { [version]$_.Name } | select -Last 1 -ExpandProperty Name
$buildSystem = ls -Directory "C:\Qt\$latestQtVersion" | where { $_.Name -match '^(msvc|mingw|llvm-mingw)' } | select -First 1 -ExpandProperty Name
Write-Host "Using Qt $latestQtVersion with $buildSystem..."

Write-Host "Copying Qt/QML DLLs via windeployqt..."
& "C:\Qt\$latestQtVersion\$buildSystem\bin\windeployqt.exe" --qmldir "C:/Qt/$latestQtVersion/$buildSystem/qml" .\appsrc.exe
Write-Host "Copying Qt6Core5Compat.dll..."
cp "C:\Qt\$latestQtVersion\$buildSystem\bin\Qt6Core5Compat.dll" .\

Write-Host "Renaming EXE..."
ren .\appsrc.exe ModpackUpdateManager.exe

Write-Host "Done!`nEXE available at '$PWD\ModpackUpdateManager.exe'.`nDistribute EXE with the entire contents of 'dist'!"
