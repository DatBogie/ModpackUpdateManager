# ModpackUpdateManager

QtQuick app to manage Minecraft modpack updates.  
Provides services for both users and modpack authors.

Designed to avoid removing any additional mods added by players.

> [!Note]
> All features are currently planned and are not yet included.  
> This is my first ever QtQuick/QML project, so I'm very much learning as I go! (Progress will be rather slow.)

## Features (Users)

1. View/update compatible [Prism Launcher](https://prismlauncher.org) instances.

2. Manually import other Minecraft instances from other launchers.

3. View changelog/version history of compatible modpacks.

4. Recieve a notification or automatically update compatible modpacks upon launching this app.

5. Automatically launch this app upon system start.

## Features (Modpack Authors)

1. View your [Prism Launcher](https://prismlauncher.org) instances and set up updates by linking a GitHub repository.

2. Generate an initial version based on an instance's mods folder.

3. Manually mark cosmetic/client-side mods as "unimportant" to allow players to remove should they wish, even when updating to newer versions of a modpack that also include them.

4. Generate new versions and their changelogs based on changes to the mods folder.

5. Automatically make changes to the linked GitHub repository if an API key is provided.
