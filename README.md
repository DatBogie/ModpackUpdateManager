# ModpackUpdateManager

A cross-platform QtQuick app for non-destructively updating Minecraft modpacks.  
Provides services for both users and modpack authors.

Designed to avoid removing any additional mods added by players.

> [!Important]
> All features are currently planned, but some are not yet implemented!  
> *You can tell if one is implemented by it having a checked/ticked box next to it.*  
> This is my first ever QtQuick/QML project, so I'm very much learning as I go! (Progress will be rather slow.)

## [Downloads](https://github.com/DatBogie/ModpackUpdateManager/releases/latest)

## Technology

Modpack Update Manager depends on the following third-party projects:

### Bundled Libraries

- [QuaZip](https://github.com/stachenov/quazip/) ([GPL v2.1 LICENSE](https://raw.githubusercontent.com/stachenov/quazip/refs/heads/master/COPYING/))
- [libgit2](https://github.com/libgit2/libgit2) ([GPL v2 LICENSE](https://raw.githubusercontent.com/libgit2/libgit2/refs/heads/main/COPYING/))
- [Qt 6](https://www.qt.io/development/qt-framework/qt6) ([LGPL v3 LICENSE](https://doc.qt.io/qt-6/lgpl.html))

### Indirect Dependancies\*

- [Prism Launcher](https://prismlauncher.org/)
- [vcpkg](https://vcpkg.io)

<sup>\**No source code has been directly used/included in this application, but Modpack Update Manager still relies on these being installed.*</sup>

## Features (Users)

1. [x] View/update compatible [Prism Launcher](https://prismlauncher.org/) instances.

2. [x] Manually import Prism Launcher Minecraft instance `ZIP`s. *Please just import from Prism Launcher directly, though! :)*

3. [ ] View changelog/version history of compatible modpacks.

4. [ ] Recieve a notification or automatically update compatible modpacks upon launching this app.

5. [ ] Automatically launch this app upon system start.

## Features (Modpack Authors)

1. [x] View your [Prism Launcher](https://prismlauncher.org/) instances and set up updates by linking a GitHub repository.

2. [ ] Manually mark cosmetic/client-side mods and config files as "unimportant" to allow players to remove should they wish, even when updating to newer versions of a modpack that also include them.

3. [x] Generate new versions and their changelogs based on changes to the `mods` & `config` folders. *Manual `git` management is required! (Just `git add . && git commit -m "<message>" && git push -u origin main`.)*

4. [ ] Automatically make changes to the linked GitHub repository if an API key is provided.

## Installation (Source)

### Prerequisites

- [CMake ≥3.16](https://cmake.org/download/)
- [Git](https://git-scm.com/install/)
- Windows: [Visual Studio ≥2022](https://visualstudio.microsoft.com/downloads/)
- Linux: GCC
- [Qt ≥6.10](https://my.qt.io/download)\*
- [vcpkg](#install-vcpkg)

<sup>\**An account is required, though this is the best way to install a specific version of Qt on any platform.*</sup>

> [!Important]
> Some steps will ask for certain values to be manually entered by you. These are indicated by a word surrounded by `<>`s, like `<username>`.
>
> - `<username>`: Your computer user's username.
> - `<version>`: The version of Qt you installed via Qt Maintenance Tool. Eg. `6.11.1`.
> - `<year>`: (**Windows Only**) The year of the Visual Studio compiler you're using. Eg. `2022`.

### Install vcpkg

1. Clone the [vcpkg repository](https://github.com/microsoft/vcpkg):

    ```sh
    cd
    git clone https://github.com/microsoft/vcpkg.git
    cd vcpkg
    ```

2. Bootstrap vcpkg;

    **Windows**

    ```powershell
    .\bootstrap-vcpkg.bat
    ```

    **Linux/macOS**

    ```sh
    ./bootstrap-vcpkg.sh
    ```

### Install Modpack Update Manager

1. Clone Modpack Update Manager:

    **Windows**

    ```powershell
    cd
    git clone --recursive https://github.com/DatBogie/ModpackUpdateManager.git
    cd ModpackManager\src
    ```

    **Linux/macOS**

    ```sh
    cd
    git clone --recursive https://github.com/DatBogie/ModpackUpdateManager.git
    cd ModpackManager/src
    ```

2. Open in Qt Creator (`File > Open File or Project...`, select `ModpackUpdateManager/src/CMakeLists.txt` from your user directory).

3. Make sure only one kit named something like `Desktop Qt...` is selected alongside only selecting its corresponding `Release` profile.

4. Hover over your selected kit and click `Manage...`.

5. Scroll down and click the `Change...` button next to `CMake Configuration:`.

6. Append one of the following and click `Apply` and `OK`, then click `Apply` and `OK` again:

    **Windows**

    ```plaintext
    -DCMAKE_TOOLCHAIN_FILE=C:/Users/<username>/vcpkg/scripts/buildsystems/vcpkg.cmake
    ```

    **Linux**

    ```plaintext
    -DCMAKE_TOOLCHAIN_FILE=/home/<username>/vcpkg/scripts/buildsystems/vcpkg.cmake
    ```

    **macOS**

    ```plaintext
    -DCMAKE_TOOLCHAIN_FILE=/Users/<username>/vcpkg/scripts/buildsystems/vcpkg.cmake
    ```

7. Click `Configure Project`, then wait for it to finish `Configuring src` and `Indexing src...`.

8. Press `CTRL+B` or click the hammer icon in the bottom left.

9. If you're ***not*** on Windows, in `~/ModpackUpdateManager/src` run:

    **Linux**

    ```sh
    ./package-linux.bash
    ```

    **macOS**

    ```sh
    ./package-macos.bash
    ```

10. If you're ***not*** on Windows, run:

    ```sh
    cd build && -- */
    ```

    You'll then find your executable at `./ModpackUpdateManager` or `./ModpackUpdateManager.app` for Linux/macOS respectively!

    *You are now finished and no longer need to follow the proceeding instructions, as they are only for Windows!*

---

From here, you can either run the packaging script, or manually package it (doing what the script does manually).  
I'd recommend running the script *unless your Qt folder **isn't** located at `C:\Qt`!*

#### Using `package.ps1`

1. In File Explorer, navigate to `$HOME\ModpackUpdateManager\src\`.

2. Right-click on `package.ps1` and click `Run with PowerShell`.

3. Once the script finishes running, you'll be able to find the compiled program in the directory shown by the script!

4. Close the PowerShell window.

#### Packaging Manually

1. In File Explorer, open `$HOME\ModpackUpdateManager\src\build` and open the first/only folder in there.

2. Make a new folder called `dist`, and copy `appsrc.exe`, `git2.dll`, `pcre.dll`, and `z.dll` into it.

3. Open `external\quazip\quazip` and copy `bz2.dll` and `quazip1-qt6.dll` into the same `dist` folder.

4. In a PowerShell terminal, type the following, then press `Tab`:

    ```powershell
    cd (ls -Directory $HOME\ModpackUpdateManager\src\build)
    ```

5. Enter the following and press `Enter`, clicking `Paste anyway` if a warning pops up:

    ```powershell
    C:\Qt\<version>\msvc<year>_64\bin\windeployqt.exe --qmldir C:/Qt/<version>/msvc<year>_64/bin/qml .\appsrc.exe
    cp C:\Qt\<version>\msvc<year>_64\bin\Qt6Core5Compat.dll .
    ```

    *If, for whatever reason, your Qt folder isn't located at `C:\Qt`, then change `C:\Qt` above to wherever it is!*

    *You are now finished!*
