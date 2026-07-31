# ModpackUpdateManager

QtQuick app to manage Minecraft modpack updates.  
Provides services for both users and modpack authors.

Designed to avoid removing any additional mods added by players.

> [!Important]
> All features are currently planned, but some are not yet implemented!  
> This is my first ever QtQuick/QML project, so I'm very much learning as I go! (Progress will be rather slow.)

## [Downloads](https://github.com/DatBogie/ModpackUpdateManager/releases/latest)

## Technology

Modpack Update Manager depends on the following third-party projects:

### Bundled Libraries

- [QuaZip](https://github.com/stachenov/quazip/) ([GPL v2.1 LICENSE](https://raw.githubusercontent.com/stachenov/quazip/refs/heads/master/COPYING/))
- [libgit2](https://github.com/libgit2/libgit2) ([GPL v2 LICENSE](https://raw.githubusercontent.com/libgit2/libgit2/refs/heads/main/COPYING/))

### Indirect Dependancies\*

- [Prism Launcher](https://prismlauncher.org/)
- [vcpkg](https://vcpkg.io)

<sup>\**No source code has been directly used/included in this application, but Modpack Update Manager still relies on these being installed.*</sup>

## Features (Users)

1. [x] View/update compatible [Prism Launcher](https://prismlauncher.org/) instances.

2. [x] Manually import Prism Launcher Minecraft instance `ZIP`s. *Please just import from Prism Launcher directly, though :)*

3. [ ] View changelog/version history of compatible modpacks.

4. [ ] Recieve a notification or automatically update compatible modpacks upon launching this app.

5. [ ] Automatically launch this app upon system start.

## Features (Modpack Authors)

1. [x] View your [Prism Launcher](https://prismlauncher.org/) instances and set up updates by linking a GitHub repository.

2. [ ] Manually mark cosmetic/client-side mods and config files as "unimportant" to allow players to remove should they wish, even when updating to newer versions of a modpack that also include them.

3. [x] Generate new versions and their changelogs based on changes to the `mods` & `config` folders. *Manual `git` management is required! (Just `git add . && git commit -m "<message>" && git push -u origin main`)*

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
> - `<username>`: Your computer user's username.  
> - `<version>`: The version of Qt you installed via Qt Maintenance Tool. Eg. `6.11.1`.  
> - `<year>`: (**Windows Only**) The year of the Visual Studio compiler you're using. Eg. `2022`.

### Install vcpkg

1. Clone the [vcpkg repository](https://github.com/microsoft/vcpkg).

    ```sh
    cd
    git clone https://github.com/microsoft/vcpkg.git
    cd vcpkg
    ```

2. Bootstrap vcpkg.

    **Windows**

    ```powershell
    .\bootstrap-vcpkg.bat
    ```

    **Linux**

    ```sh
    ./bootstrap-vcpkg.sh
    ```

### Install Modpack Update Manager

1. Clone Modpack Update Manager

    **Windows**

    ```powershell
    cd
    git clone --recursive https://github.com/DatBogie/ModpackUpdateManager.git
    cd ModpackManager\src
    ```

    **Linux**
   
    ```sh
    cd
    git clone --recursive https://github.com/DatBogie/ModpackUpdateManager.git
    cd ModpackManager/src
    ```

3. Open in Qt Creator (`File > Open File or Project...`, select `ModpackUpdateManager/src/CMakeLists.txt` from your user directory)

4. ***If on Windows***, check only `Desktop Qt <version> MSVC<year> 64bit` and its corresponding check `Release`. ***Otherwise***, just pick one of them and check only `Release` for it.

5.  Hover over `Desktop Qt <version> MSVC<year> 64bit` (or whichever one you picked) and click `Manage...`.

6.  Scroll down and click the `Change...` button next to `CMake Configuration:`

7.  Append one of the following and click `Apply` and `OK`, then click `Apply` and `OK` again:

    **Windows**

    ```
    -DCMAKE_TOOLCHAIN_FILE=C:/Users/<username>/vcpkg/scripts/buildsystems/vcpkg.cmake
    ```

    **Linux**

    ```
    -DCMAKE_TOOLCHAIN_FILE=/home/<username>/vcpkg/scripts/buildsystems/vcpkg.cmake
    ```

8. Click `Configure Project`, then wait for it to finish `Configuring src` and `Indexing src...`

9. Press `CTRL+B` or click the hammer icon in the bottom left

10. Open your file manager and navigate to `$HOME/ModpackUpdateManager/src/build` and open the folder inside

11. ***If you're on linux, you're done! The binary is called `appsrc`. You may stop following these instructions!***

12. Make a new folder called `dist`, and copy `appsrc.exe`, `git2.dll`, `pcre.dll`, and `z.dll` into it.

13. Open `external\quazip\quazip` and copy `bz2.dll` and `quazip1-qt6.dll` into the same `dist` folder.

14. In a PowerShell terminal, type the following, then press `TAB`:

    ```powershell
    cd $HOME\ModpackUpdateManager\src\build\
    ```
    
15. Then, type `dist` and press `Enter`

16. Enter the following and press `Enter`:

    ```powershell
    C:\Qt\<version>\msvc<year>_64\bin\windeployqt.exe --qmldir C:/Qt/<version>/msvc<year>_64/bin/qml .\appsrc.exe
    cp C:\Qt\<version>\msvc<year>_64\bin\Qt6Core5Compat.dll .\
    ```

17. That's it! Unlike on Linux, though, you have to move the entire `dist` folder, not just the executable. Feel free to rename both, though! Just don't touch the `.dll`s.
