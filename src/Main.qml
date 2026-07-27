import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Dialogs

ApplicationWindow {
    id: window
    width: 1024
    height: 600
    minimumWidth: 640
    minimumHeight: 480
    visible: true
    title: qsTr("Modpack Update Manager")

    /* Colors */
    property color rosewater: "#f4dbd6"
    property color flamingo: "#f0c6c6"
    property color pink: "#f5bde6"
    property color mauve: "#c6a0f6"
    property color red: "#ed8796"
    property color maroon: "#ee99a0"
    property color peach: "#f5a97f"
    property color yellow: "#eed49f"
    property color green: "#a6da95"
    property color teal: "#8bd5ca"
    property color sky: "#91d7e3"
    property color sapphire: "#7dc4e4"
    property color blue: "#8aadf4"
    property color lavender: "#b7bdf8"
    property color text: "#cad3f5"
    property color subtext1: "#b8c0e0"
    property color subtext0: "#a5adcb"
    property color overlay2: "#939ab7"
    property color overlay1: "#8087a2"
    property color overlay0: "#6e738d"
    property color surface2: "#5b6078"
    property color surface1: "#494d64"
    property color surface0: "#363a4f"
    property color base: "#24273a"
    property color mantle: "#1e2030"
    property color crust: "#181926"
    property color accent: window.lavender

    property int globalCtrlSize: 25
    property int globalPadding: 5
    property int globalBorderRadius: 10
    property real globalIconScale: .8
    property real globalModpackScale: .85
    property int globalHeaderSize: 18
    property int globalTextSize: 14

    function capitalizeFirst(x) {
        return x.substring(0,1).toUpperCase()+x.substring(1);
    }

    function pt2px(pt) {
        return pt*(1/.75);
    }

    color: window.crust

    Window {
        id: globalSetupWizardWindow
        visible: false
        property var mi: ({ index: 0, name: "", thumbnailKey: "", thumbnailParentPath: "", packEnabled: false, fromPrism: true, isCompatible: false, updateUrl: "", currentVersionId: "", currentVersionType: "", instancePath: "" });
        title: `${mi.name} — Modpack Setup Wizard`
        width: 600
        height: 400
        minimumWidth: width
        minimumHeight: height
        maximumWidth: width
        maximumHeight: height
        color: window.color

        onVisibleChanged: {
            if (!visible) {
                globalSetupWizard.currentIndex = 0;
                return;
            }
            globalSetupWizardUrl.text = "";
            globalSetupWizardVersionId.text = "";
        }

        property color childColor: window.surface0
        property color childPressColor: window.surface1

        Item {
            width: parent.width-window.globalPadding*2
            height: parent.height-window.globalPadding*2
            anchors.centerIn: parent

            Rectangle {
                id: globalSetupWizardNavbar
                property real textSize: window.globalTextSize
                color: window.base
                height: textSize*2;
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                radius: window.globalBorderRadius

                Text {
                    anchors {
                        left: parent.left
                        right: globalSetupWizardNavbarTicker.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    color: window.text
                    text: `${globalSetupWizardWindow.mi.name} — ${globalSetupWizard.currentItem.pageTitle}`
                    elide: Text.ElideMiddle
                    ToolTip.text: text
                    ToolTip.visible: globalSetupWizardNavbarTitleMs.containsMouse
                    font.pointSize: globalSetupWizardNavbar.textSize
                    horizontalAlignment: Text.AlignHCenter
                    leftPadding: window.globalPadding
                    rightPadding: window.globalPadding
                    MouseArea {
                        id: globalSetupWizardNavbarTitleMs
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                Text {
                    id: globalSetupWizardNavbarTicker
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    color: window.text
                    text: `(${globalSetupWizard.currentIndex+1}/${globalSetupWizard.count})`
                    font.pointSize: globalSetupWizardNavbar.textSize
                    horizontalAlignment: Text.AlignRight
                    leftPadding: window.globalPadding
                    rightPadding: window.globalPadding
                }
            }

            Rectangle {
                color: window.crust
                anchors {
                    left: parent.left
                    right: parent.right
                    top: globalSetupWizardNavbar.bottom
                    bottom: globalSetupWizardControls.parent.top
                }

                SwipeView {
                    id: globalSetupWizard
                    interactive: false
                    anchors.fill: parent
                    clip: true

                    Item {
                        property string pageTitle: "Linking a GitHub Repository"
                        Column {
                            width: parent.width
                            height: parent.height-window.globalPadding*2
                            anchors {
                                centerIn: parent
                            }
                            spacing: window.globalPadding

                            TextEdit {
                                property bool linkHover: false
                                width: parent.width
                                textFormat: Text.MarkdownText
                                text: "1. Go to [_GitHub_](https://github.com/signup)\n2. [_Create a *public* repository_](https://github.com/new). Its name doesn't matter!\n3. Copy the url and paste it in the box below.\n4. Click the `Add file` dropdown, then click `Create new file`.\n5. Name it `modpackupdatemanager.json`, then copy the code from [_here_](https://raw.githubusercontent.com/DatBogie/ModpackUpdateManager-ExamplePack/refs/heads/main/modpackupdatemanager.json) and paste it into the editor, then press `Commit changes` twice."
                                wrapMode: Text.Wrap
                                color: window.text
                                onLinkHovered: link=>{ linkHover = link !== "" }
                                onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                                font.pointSize: window.globalTextSize
                                topPadding: window.globalPadding
                                readOnly: true

                                HoverHandler {
                                    cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.IBeamCursor
                                }
                            }

                            TextField {
                                property string outputText: text === ""? "1.0.1" : text
                                id: globalSetupWizardUrl
                                placeholderText: "Enter GitHub Repo Url (eg. https://github.com/<user>/<name>)..."
                                width: parent.width
                                background: Rectangle {
                                    color: globalSetupWizardWindow.childColor
                                    radius: window.globalBorderRadius
                                }
                            }
                        }
                    }

                    Item {
                        property string pageTitle: "Creating New Versions"
                        Column {
                            width: parent.width
                            height: parent.height-window.globalPadding*2
                            anchors {
                                centerIn: parent
                            }
                            spacing: window.globalPadding

                            TextField {
                                property string outputText: text === ""? "1.0.1" : text
                                id: globalSetupWizardVersionId
                                placeholderText: "Enter new Version Id (eg. 1.0.1)..."
                                width: parent.width
                                background: Rectangle {
                                    color: globalSetupWizardWindow.childColor
                                    radius: window.globalBorderRadius
                                }
                            }

                            TextEdit {
                                property bool linkHover: false
                                width: parent.width
                                textFormat: Text.MarkdownText
                                text: `1. Go to the root of your repo.\n2. Create a new file called \`versions/${globalSetupWizardVersionId.outputText}/mods/.DS_Store\` and commit.\n3. Click \`Upload files\` under \`Add file\` and upload any mods you're adding to or updating in this new version!`
                                wrapMode: Text.Wrap
                                color: window.text
                                onLinkHovered: link=>{ linkHover = link !== "" }
                                onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                                font.pointSize: window.globalTextSize
                                readOnly: true

                                HoverHandler {
                                    cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.IBeamCursor
                                }
                            }
                        }
                    }

                    Item {
                        property string pageTitle: "Done!"
                        Text {
                            property bool linkHover: false
                            width: parent.width
                            textFormat: Text.MarkdownText
                            text: "- Click `Finish` below to complete the setup."
                            wrapMode: Text.Wrap
                            color: window.text
                            onLinkHovered: link=>{ linkHover = link !== "" }
                            onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                            font.pointSize: window.globalTextSize
                            topPadding: window.globalPadding

                            HoverHandler {
                                cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.IBeamCursor
                            }
                        }
                    }
                }
            }

            Rectangle {
                color: window.base
                height: window.globalCtrlSize+window.globalPadding*2
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                radius: window.globalBorderRadius

                RowLayout {
                    id: globalSetupWizardControls
                    spacing: window.globalPadding
                    height: window.globalCtrlSize
                    anchors {
                        left: parent.left
                        right: parent.right
                        centerIn: parent
                    }

                    Button {
                        id: globalSetupWizardBackBtn
                        visible: globalSetupWizard.currentIndex > 0
                        enabled: visible
                        padding: 0
                        property string btnText: "Back"
                        Layout.fillHeight: true
                        background: Rectangle {
                            color: !parent.down? globalSetupWizardWindow.childColor : globalSetupWizardWindow.childPressColor
                            radius: window.globalBorderRadius
                        }
                        onClicked: {
                            globalSetupWizard.currentIndex--;
                        }

                        contentItem: RowLayout {
                            height: parent.height
                            spacing: 0

                            Image {
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                scale: window.globalIconScale
                                source: "assets/arrow_left_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                text: parent.parent.btnText
                                horizontalAlignment: Text.AlignLeft
                                color: window.text
                                rightPadding: window.globalPadding
                            }
                        }
                    }

                    Button {
                        id: globalSetupWizardNextBtn
                        visible: (globalSetupWizard.currentIndex !== 0 || globalSetupWizardUrl.text.startsWith("https://github.com/")) && (globalSetupWizard.currentIndex < globalSetupWizard.count-1)
                        enabled: visible
                        padding: 0
                        property string btnText: "Next"
                        Layout.fillHeight: true
                        background: Rectangle {
                            color: !parent.down? globalSetupWizardWindow.childColor : globalSetupWizardWindow.childPressColor
                            radius: window.globalBorderRadius
                        }
                        onClicked: globalSetupWizard.currentIndex++

                        contentItem: RowLayout {
                            height: parent.height
                            spacing: 0

                            Text {
                                text: parent.parent.btnText
                                horizontalAlignment: Text.AlignRight
                                color: window.text
                                leftPadding: window.globalPadding
                            }

                            Image {
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                scale: window.globalIconScale
                                source: "assets/arrow_right_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                        }
                    }

                    Button {
                        id: globalSetupWizardFinishBtn
                        visible: globalSetupWizard.currentIndex >= globalSetupWizard.count-1
                        enabled: visible
                        padding: 0
                        property string btnText: "Finish"
                        Layout.fillHeight: true
                        background: Rectangle {
                            color: !parent.down? globalSetupWizardWindow.childColor : globalSetupWizardWindow.childPressColor
                            radius: window.globalBorderRadius
                        }
                        onClicked: {
                            globalSetupWizardWindow.visible = false;
                            globalSetupWizardWindow.mi.updateUrl = globalSetupWizardUrl.text;
                            backend.setUpdateUrlProperty(globalSetupWizardWindow.mi.index, globalSetupWizardWindow.mi.updateUrl);
                            globalMessageDialog.title = globalSetupWizardWindow.title;
                            globalMessageDialog.text = `## ${globalSetupWizardWindow.mi.name}\n\n --- \n\n**Setup ${backend.setupPack(globalSetupWizardWindow.mi)? "Completed Successfully!" : "Failed!"}**`;
                            globalMessageDialog.visible = true;
                        }

                        contentItem: RowLayout {
                            height: parent.height
                            spacing: 0

                            Image {
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                scale: window.globalIconScale
                                source: "assets/check_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                fillMode: Image.PreserveAspectFit
                                MultiEffect {
                                    anchors.fill: parent
                                    source: parent
                                    colorization: 1.0
                                    colorizationColor: window.green
                                }
                            }

                            Text {
                                text: parent.parent.btnText
                                horizontalAlignment: Text.AlignLeft
                                color: window.text
                                rightPadding: window.globalPadding
                            }
                        }
                    }
                }
            }
        }
    }

    Window {
        id: globalMessageDialog
        visible: false
        property string text: ""
        property color childColor: window.surface0
        property color childPressColor: window.surface1
        width: 600
        height: 350
        minimumWidth: width
        minimumHeight: height
        maximumWidth: width
        maximumHeight: height
        color: window.color

        Item {
            width: parent.width-window.globalPadding*2
            height: parent.height-window.globalPadding*2
            anchors.centerIn: parent

            ScrollView {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: globalMessageDialogControls.top
                }

                Text {
                    property bool linkHover: false
                    width: parent.width
                    textFormat: Text.MarkdownText
                    text: globalMessageDialog.text
                    wrapMode: Text.Wrap
                    color: window.text
                    onLinkHovered: link=>{ linkHover = link !== "" }
                    onLinkActivated: link=>{ Qt.openUrlExternally(link) }
                    font.pointSize: window.globalTextSize
                    topPadding: window.globalPadding

                    HoverHandler {
                        cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
            }

            RowLayout {
                id: globalMessageDialogControls
                height: window.globalCtrlSize
                spacing: window.globalPadding

                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                Item { Layout.fillWidth: true }

                Button {
                    id: globalMessageDialogOKBtn
                    padding: 0
                    property string btnText: "Okay"
                    Layout.fillHeight: true
                    background: Rectangle {
                        color: !parent.down? globalMessageDialog.childColor : globalMessageDialog.childPressColor
                        radius: window.globalBorderRadius
                    }
                    onClicked: globalMessageDialog.visible = false

                    contentItem: RowLayout {
                        height: parent.height
                        spacing: 0

                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            scale: window.globalIconScale
                            source: "assets/check_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                            fillMode: Image.PreserveAspectFit
                            MultiEffect {
                                anchors.fill: parent
                                source: parent
                                colorization: 1.0
                                colorizationColor: window.green
                            }
                        }

                        Text {
                            text: parent.parent.btnText
                            horizontalAlignment: Text.AlignLeft
                            color: window.text
                            rightPadding: window.globalPadding
                        }
                    }
                }

                Button {
                    id: globalMessageDialogCloseBtn
                    visible: false
                    enabled: visible
                    padding: 0
                    property string btnText: "Close"
                    Layout.fillHeight: true
                    background: Rectangle {
                        color: !parent.down? globalMessageDialog.childColor : globalMessageDialog.childPressColor
                        radius: window.globalBorderRadius
                    }
                    onClicked: globalMessageDialog.visible = false

                    contentItem: RowLayout {
                        height: parent.height
                        spacing: 0

                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            scale: window.globalIconScale
                            source: "assets/close_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                            fillMode: Image.PreserveAspectFit
                            MultiEffect {
                                anchors.fill: parent
                                source: parent
                                colorization: 1.0
                                colorizationColor: window.red
                            }
                        }

                        Text {
                            text: parent.parent.btnText
                            horizontalAlignment: Text.AlignLeft
                            color: window.text
                            rightPadding: window.globalPadding
                        }
                    }
                }
            }
        }
    }

    Component {
        id: modpackGridItem
        Item {
            id: item
            width: modpackGrid.cellWidth
            height: modpackGrid.cellHeight
            Button {
                anchors.centerIn: parent
                background: Rectangle {
                    // color: !parent.down? labelContainer.color : labelContainer.childPressColor
                    color: window.base
                    radius: window.globalBorderRadius
                }
                implicitWidth: modpackGrid.cellWidth-window.globalPadding
                implicitHeight: modpackGrid.cellHeight-window.globalPadding

                contentItem: Item {
                    id: content
                    anchors.fill: parent

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: mask
                        maskThresholdMin: .5
                        maskSpreadAtMin: 1
                    }

                    Rectangle {
                        id: mask
                        anchors.fill: parent
                        radius: window.globalBorderRadius
                        visible: false
                        layer.enabled: true
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            bottom: labelContainer.top
                        }
                        color: window.surface0

                        AnimatedImage {
                            id: thumbnail
                            anchors.fill: parent
                            fillMode: sourceSize.width == sourceSize.height? Image.PreserveAspectFit : Image.PreserveAspectCrop
                            source: "file:"+thumbnailParentPath+thumbnailKey
                            onStatusChanged: {
                                if (status !== Image.Error) return;
                                source = "assets/hide_image_800dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.svg";
                            }
                        }
                    }

                    Rectangle {
                        id: labelContainer
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        height: 25
                        color: window.base

                        property color childPressColor: window.surface0

                        RowLayout {
                            anchors.fill: parent
                            Label {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.fillWidth: true
                                horizontalAlignment: "AlignLeft"
                                verticalAlignment: "AlignVCenter"
                                text: name
                                leftPadding: window.globalPadding
                                color: window.text
                                elide: Text.ElideRight
                            }

                            RowLayout {
                                spacing: 0

                                Button {
                                    id: compat
                                    visible: !isCompatible
                                    enabled: visible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    ToolTip.text: "Setup Modpack Updates..."
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    onClicked: {
                                        const mi = parent.genmiDict();
                                        mi.index = index;
                                        globalSetupWizardWindow.mi = mi;
                                        globalSetupWizardWindow.visible = true;
                                    }

                                    contentItem: Image {
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: "assets/add_task_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                Button {
                                    id: info
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    ToolTip.text: "View Details..."
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    onClicked: {
                                        modalBackground.visible = true;
                                        modpackDetails.enabled = true;
                                        modpackDetails.instanceName = name;
                                        modpackDetails.thumbnailSource = "file:/"+thumbnailParentPath+thumbnailKey;
                                        modpackDetails.isCompatible = isCompatible
                                        modpackDetails.updateUrl = !isCompatible? "" : updateUrl;
                                        modpackDetails.currentVersionId = !isCompatible? "" : currentVersionId;
                                        modpackDetails.currentVersionType = !isCompatible? "" : currentVersionType;
                                    }

                                    contentItem: Image {
                                        id: infoBtnIcon
                                        visible: false
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: "assets/info_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MultiEffect {
                                        scale: infoBtnIcon.scale
                                        anchors.fill: infoBtnIcon
                                        source: infoBtnIcon
                                        colorization: 1.0
                                        colorizationColor: window.sky
                                    }
                                }

                                function genmi(includeUpdate=true) {
                                    return [ name, thumbnailKey, thumbnailParentPath, packEnabled, fromPrism, isCompatible, updateUrl, currentVersionId, currentVersionType, instancePath, includeUpdate? pendingUpdate : undefined ];
                                }

                                function genmiDict() {
                                    return { name: name, thumbnailKey: thumbnailKey, thumbnailParentPath: thumbnailParentPath, packEnabled: packEnabled, fromPrism: fromPrism, isCompatible: isCompatible, updateUrl: updateUrl, currentVersionId: currentVersionId, currentVersionType: currentVersionType, instancePath: instancePath };
                                }

                                function updateInstance(mi) {
                                    const updateResponse = backend.qmlUpdateInstance(mi);
                                    globalMessageDialog.title = `${name} — Modpack Update Fetcher`;
                                    globalMessageDialog.text = `## ${name} \n\n --- \n\n` + (updateResponse.success? `**Update successful!**  \n"${updateResponse.updateName}" (${updateResponse.updateId})  \n${updateResponse.updateDesc}` : "**Update failed!**  \nCheck the log for more info.");
                                    globalMessageDialog.visible = true;
                                    if (updateResponse.success) {
                                        backend.setPendingUpdateProperty(index, { hasUpdate: false });
                                        backend.setCurrentVersionIdProperty(index, updateResponse.updateId);
                                        backend.setCurrentVersionTypeProperty(index, updateResponse.updateType);
                                    }

                                    return updateResponse;
                                }

                                Button {
                                    id: updateCheck
                                    visible: isCompatible
                                    enabled: visible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }

                                    ToolTip.text: "Check for Updates"+(update.trulyEnabled? "" : " & Update")
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    onClicked: {
                                        const mi = parent.genmi(false);
                                        const response = backend.qmlCheckUpdate(mi);
                                        backend.setPendingUpdateProperty(index, response);
                                        globalMessageDialog.title = `${name} — Modpack Update Fetcher`;
                                        globalMessageDialog.text = `## ${name}\n\n --- \n\n` + (response.hasUpdate? `**Pending update:** "${response.updateName}" (${response.updateId})  \n${response.updateDesc}` : "No updates found!");
                                        if (update.trulyEnabled || !response.hasUpdate) {
                                            globalMessageDialog.visible = true;
                                            return;
                                        }
                                        parent.updateInstance(parent.genmi());
                                    }

                                    contentItem: Image {
                                        id: updateCheckBtnIcon
                                        visible: false
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: update.trulyEnabled? "assets/update_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg" : "assets/update-download_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MultiEffect {
                                        scale: updateCheckBtnIcon.scale
                                        anchors.fill: updateCheckBtnIcon
                                        source: updateCheckBtnIcon
                                        colorization: 1.0
                                        colorizationColor: window.rosewater
                                    }
                                }

                                Button {
                                    id: update
                                    property bool trulyEnabled: isCompatible && !packEnabled;
                                    visible: pendingUpdate.hasUpdate && (isCompatible && !packEnabled)
                                    enabled: visible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    ToolTip.text: "Update" + (pendingUpdate.hasUpdate? " (Pending)" : "")
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    onClicked: {
                                        const mi = parent.genmi();
                                        parent.updateInstance(mi);
                                    }

                                    contentItem: Image {
                                        id: updateBtnIcon
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: "assets/download_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                Button {
                                    id: enabled
                                    visible: isCompatible
                                    enabled: visible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    onClicked: backend.setEnabledProperty(index, !packEnabled, name)

                                    ToolTip.text: "Modpack Auto-Updates: "+(packEnabled? "Enabled" : "Disabled")
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    contentItem: Image {
                                        id: enabledBtnIcon
                                        visible: false
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: packEnabled? "assets/check_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg" : "assets/close_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MultiEffect {
                                        scale: enabledBtnIcon.scale
                                        anchors.fill: enabledBtnIcon
                                        source: enabledBtnIcon
                                        colorization: 1.0
                                        colorizationColor: packEnabled? window.green : window.red
                                    }
                                }

                                Button {
                                    id: remove
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    onClicked: {
                                        backend.permRemoveInstance(index);
                                    }

                                    ToolTip.text: "Remove from List"
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    contentItem: Image {
                                        id: removeBtnIcon
                                        visible: false
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: "assets/remove_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MultiEffect {
                                        scale: removeBtnIcon.scale
                                        anchors.fill: removeBtnIcon
                                        source: removeBtnIcon
                                        colorization: 1.0
                                        colorizationColor: window.lavender
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: windowContent
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: window.color
        }

        ColumnLayout {
            anchors {
                fill: parent
                margins: window.globalPadding
            }

            RowLayout {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                height: 50
                property color childColor: window.base
                property color childPressColor: window.surface0

                Text {
                    color: window.text
                    text: "Instances"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignBottom
                    padding: window.globalPadding
                    bottomPadding: -window.globalPadding/2
                    font.pointSize: window.globalHeaderSize
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: parent.height-window.globalPadding/2
                    color: window.color

                    Rectangle {
                        color: parent.parent.childColor
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                        }
                        height: window.globalCtrlSize-window.globalPadding/2
                        width: childrenRect.width
                        radius: window.globalBorderRadius

                        RowLayout {
                            Layout.fillHeight: true

                            Button {
                                id: uploadInstance
                                background: Rectangle {
                                    color: !parent.down? parent.parent.parent.parent.parent.childColor : parent.parent.parent.parent.parent.childPressColor
                                    radius: window.globalBorderRadius
                                }
                                ToolTip.text: "Upload Instance (.zip)..."
                                ToolTip.visible: hovered
                                implicitWidth: parent.parent.height
                                implicitHeight: implicitWidth

                                contentItem: Image {
                                    anchors.fill: parent
                                    scale: window.globalIconScale
                                    source: "assets/upload_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                    fillMode: Image.PreserveAspectFit
                                }

                                FileDialog {
                                    id: zipDia
                                    nameFilters: [
                                        "Prism Launcher Instances (*.zip)"
                                    ]
                                    onAccepted: backend.importInstance(selectedFile)
                                }

                                onClicked: zipDia.open()
                            }

                            Button {
                                id: refreshInstances
                                background: Rectangle {
                                    color: parent.enabled? (!parent.down? parent.parent.parent.parent.parent.childColor : parent.parent.parent.parent.parent.childPressColor) : window.color
                                    radius: window.globalBorderRadius
                                }
                                ToolTip.text: "Re-fetch Instances from Prism Launcher"
                                ToolTip.visible: hovered
                                implicitWidth: parent.parent.height
                                implicitHeight: implicitWidth

                                contentItem: Image {
                                    anchors.fill: parent
                                    scale: window.globalIconScale
                                    source: "assets/refresh_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                    fillMode: Image.PreserveAspectFit
                                }

                                onClicked: {
                                    refreshInstances.enabled = false;
                                    clearIgnoreMemory.enabled = false;
                                    backend.refreshPrismInstances();
                                    refreshInstances.enabled = true;
                                    clearIgnoreMemory.enabled = true;
                                }
                            }

                            Button {
                                id: clearIgnoreMemory
                                background: Rectangle {
                                    color: parent.enabled? (!parent.down? parent.parent.parent.parent.parent.childColor : parent.parent.parent.parent.parent.childPressColor) : window.color
                                    radius: window.globalBorderRadius
                                }
                                ToolTip.text: "Clear Memory of Ignored Modpacks"
                                ToolTip.visible: hovered
                                implicitWidth: parent.parent.height
                                implicitHeight: implicitWidth

                                contentItem: Image {
                                    anchors.fill: parent
                                    scale: window.globalIconScale
                                    source: "assets/history_toggle_off_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                    fillMode: Image.PreserveAspectFit
                                }

                                onClicked: {
                                    backend.clearIgnoreMemory();
                                    refreshInstances.enabled = false;
                                    clearIgnoreMemory.enabled = false;
                                    backend.refreshPrismInstances();
                                    refreshInstances.enabled = true;
                                    clearIgnoreMemory.enabled = true;
                                }
                            }
                        }
                    }

                    Rectangle {
                        color: parent.parent.childColor
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                        }

                        height: window.globalCtrlSize-window.globalPadding/2
                        width: childrenRect.width
                        radius: window.globalBorderRadius

                        RowLayout {
                            Layout.fillHeight: true
                            layoutDirection: Qt.RightToLeft

                            Button {
                                id: settingsBtn
                                background: Rectangle {
                                    color: !parent.down? parent.parent.parent.parent.parent.childColor : parent.parent.parent.parent.parent.childPressColor
                                    radius: window.globalBorderRadius
                                }
                                ToolTip.text: "Manage Settings..."
                                ToolTip.visible: hovered
                                implicitWidth: parent.parent.height
                                implicitHeight: implicitWidth

                                contentItem: Image {
                                    anchors.fill: parent
                                    scale: window.globalIconScale
                                    source: "assets/settings_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Button {
                                id: licenseBtn
                                background: Rectangle {
                                    color: !parent.down? parent.parent.parent.parent.parent.childColor : parent.parent.parent.parent.parent.childPressColor
                                    radius: window.globalBorderRadius
                                }
                                ToolTip.text: "View Program License..."
                                ToolTip.visible: hovered
                                implicitWidth: parent.parent.height
                                implicitHeight: implicitWidth

                                contentItem: Image {
                                    anchors.fill: parent
                                    scale: window.globalIconScale
                                    source: "assets/license_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: window.text
                height: 1
            }

            GridView {
                id: modpackGrid
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: modpackModel
                delegate: modpackGridItem
                property int minCellWidth: 250*window.globalModpackScale
                property int minCellHeight: 150*window.globalModpackScale
                property int columns: Math.max(1, Math.floor(width/minCellWidth))
                cellWidth: width/columns
                cellHeight: minCellHeight
            }
        }
    }

    Rectangle {
        id: modalBackground
        anchors.fill: parent
        color: "#00000000"
        clip: true
        visible: false

        ShaderEffectSource {
            id: modalBackdrop
            sourceItem: windowContent
            anchors.fill: parent
            sourceRect: Qt.rect(0, 0, window.width, window.height)
            live: true
            hideSource: false
        }

        MultiEffect {
            anchors.fill: parent
            source: modalBackdrop
            blurEnabled: true
            blur: 1
            blurMax: 64
            blurMultiplier: 1
            autoPaddingEnabled: false
            x: 0
            y: 0
            width: modalBackground.width
            height: modalBackground.height
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true
            scrollGestureEnabled: true
            onWheel: wheel=>{
                wheel.accepted = true;
            }
            onClicked: parent.visible = false
        }

        Rectangle {
            id: modal
            anchors.fill: parent
            color: window.base
            scale: .85
            radius: window.globalBorderRadius
            clip: true

            property int modalPadding: 50

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                scrollGestureEnabled: true
            }

            Item {
                id: modpackDetails

                property string instanceName: "N/A"
                property string thumbnailSource: ""
                property bool isCompatible: false
                property string updateUrl: ""
                property string currentVersionId: ""
                property string currentVersionType: ""

                width: parent.width-parent.modalPadding
                height: parent.height-parent.modalPadding
                anchors.centerIn: parent

                RowLayout {
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: window.globalPadding

                        ColumnLayout {
                            spacing: window.globalPadding*2

                            AnimatedImage {
                                id: thumbnail
                                property int preferredWidth: 300
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredWidth: preferredWidth
                                Layout.preferredHeight: 150
                                fillMode: Image.PreserveAspectFit
                                source: modpackDetails.thumbnailSource
                            }

                            Text {
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredWidth: thumbnail.preferredWidth
                                elide: Text.ElideRight
                                text: modpackDetails.instanceName
                                font.pointSize: window.globalHeaderSize
                                color: window.text
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle {
                            color: window.text
                            height: 1
                            Layout.preferredWidth: thumbnail.preferredWidth
                        }

                        Text {
                            property bool linkHover: false
                            visible: modpackDetails.isCompatible
                            Layout.preferredWidth: thumbnail.preferredWidth
                            wrapMode: Text.Wrap
                            text: `Version: ${window.capitalizeFirst(modpackDetails.currentVersionType)} ${modpackDetails.currentVersionId}  \nUpdate Host Url: [_GitHub_](${modpackDetails.updateUrl})`
                            textFormat: Text.MarkdownText
                            font.pointSize: window.globalTextSize
                            color: window.text
                            horizontalAlignment: Text.AlignLeft
                            onLinkHovered: link=>{ linkHover = link !== "" }
                            onLinkActivated: link=>{ Qt.openUrlExternally(link) }

                            HoverHandler {
                                cursorShape: parent.linkHover? Qt.PointingHandCursor : Qt.ArrowCursor
                            }

                        }
                    }

                    // ColumnLayout {
                    //     Layout.fillWidth: true
                    //     Layout.fillHeight: true
                    //     Text {
                    //         Layout.alignment: Qt.AlignTop
                    //         Layout.fillWidth: true
                    //         elide: Text.ElideRight
                    //         text: modpackDetails.instanceName
                    //         font.pointSize: window.globalHeaderSize
                    //         color: window.text
                    //     }
                    // }
                }
            }

            Item {
                width: parent.width-parent.modalPadding
                height: parent.height-parent.modalPadding
                anchors.centerIn: parent

                Button {
                    id: closeModal
                    anchors {
                        right: parent.right
                        top: parent.top
                    }

                    background: Rectangle {
                        color: !parent.down? window.base : window.surface0
                        radius: window.globalBorderRadius
                    }
                    width: window.globalCtrlSize
                    height: window.globalCtrlSize

                    onClicked: modalBackground.visible = false

                    contentItem: Image {
                        id: closeModalBtnIcon
                        visible: false
                        anchors.fill: parent
                        scale: window.globalIconScale
                        source: "assets/close_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    MultiEffect {
                        scale: closeModalBtnIcon.scale
                        anchors.fill: closeModalBtnIcon
                        source: closeModalBtnIcon
                        colorization: 1.0
                        colorizationColor: window.red
                    }
                }
            }
        }
    }
}
