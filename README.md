# ModpackUpdateManager

QtQuick app to manage Minecraft modpack updates.  
Provides services for both users and modpack authors.

Designed to avoid removing any additional mods added by players.

> [!Important]
> All features are currently planned, but some are not yet implemented!  
> This is my first ever QtQuick/QML project, so I'm very much learning as I go! (Progress will be rather slow.)

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

1. View/update compatible [Prism Launcher](https://prismlauncher.org/) instances.

2. Manually import other Minecraft instances from other launchers.

3. View changelog/version history of compatible modpacks.

4. Recieve a notification or automatically update compatible modpacks upon launching this app.

5. Automatically launch this app upon system start.

## Features (Modpack Authors)

1. View your [Prism Launcher](https://prismlauncher.org/) instances and set up updates by linking a GitHub repository.

2. Generate an initial version based on an instance's mods folder.

3. Manually mark cosmetic/client-side mods as "unimportant" to allow players to remove should they wish, even when updating to newer versions of a modpack that also include them.

4. Generate new versions and their changelogs based on changes to the mods folder.

5. Automatically make changes to the linked GitHub repository if an API key is provided.

## Installation (Source)

### Prerequisites

- [CMake ≥3.16](https://cmake.org/download/)
- [Git](https://git-scm.com/install/)
- Windows: [Visual Studio ≥2022](https://visualstudio.microsoft.com/downloads/)
- Linux: GCC
- [Qt ≥6.10](https://my.qt.io/download)\*
- [vcpkg](#install-vcpkg)

<sup>\**An account is required, though this is the best way to install a specific version of Qt on any platform.*</sup>

### Install vcpkg

1. Clone the [vcpkg repository](https://github.com/microsoft/vcpkg).

    ```sh
    cd
    git clone https://github.com/microsoft/vcpkg.git
    cd vcpkg
    ```

2. Bootstrap vcpkg.

    **Windows**

    ```ps
    .\bootstrap-vcpkg.bat
    ```

    **Linux**

    ```sh
    ./bootstrap-vcpkg.sh
    ```

3. Clone Modpack Update Manager

    ```sh
    cd
    git clone --recursive https://github.com/DatBogie/ModpackUpdateManager.git
    cd ModpackManager/src
    ```

4. Configure CMake

    **Windows**

    ```ps
    cmake -B build -DCMAKE_TOOLCHAIN_FILE="$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake" -DCMAKE_PREFIX_PATH=C:/Qt/<QT_VERSION>/msvc2022_64
    ```

    **Linux**

    ```sh
    cmake -B build -DCMAKE_TOOLCHAIN_FILE="$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_PREFIX_PATH=$HOME/Qt/<QT_VERSION>/gcc_64"
    ```

5. Build

    ```sh
    cmake --build build
    ```
