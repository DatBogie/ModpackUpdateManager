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

    color: window.crust

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

                                Button {
                                    id: updateCheck
                                    visible: isCompatible
                                    enabled: isCompatible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    ToolTip.text: "Check for Updates"
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

                                    contentItem: Image {
                                        id: updateCheckBtnIcon
                                        visible: false
                                        anchors.fill: parent
                                        scale: window.globalIconScale
                                        source: "assets/update_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
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
                                    visible: isCompatible
                                    enabled: isCompatible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    ToolTip.text: "Update"
                                    ToolTip.visible: hovered
                                    implicitWidth: window.globalCtrlSize

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
                                    enabled: isCompatible
                                    Layout.fillHeight: true
                                    background: Rectangle {
                                        color: !parent.down? labelContainer.color : labelContainer.childPressColor
                                        radius: window.globalBorderRadius
                                    }
                                    onClicked: packEnabled = !packEnabled
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
            sourceRect: Qt.rect(0, 0, pageContent.width, pageContent.height)
            live: false
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
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredWidth: 300
                                Layout.preferredHeight: 150
                                fillMode: Image.PreserveAspectFit
                                source: modpackDetails.thumbnailSource
                            }

                            Text {
                                Layout.alignment: Qt.AlignTop
                                Layout.fillWidth: true
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
                            Layout.fillWidth: true
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
                        id: infoBtnIcon
                        visible: false
                        anchors.fill: parent
                        scale: window.globalIconScale
                        source: "assets/close_24dp_FFFFFF_FILL0_wght400_GRAD0_opsz24.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    MultiEffect {
                        scale: infoBtnIcon.scale
                        anchors.fill: infoBtnIcon
                        source: infoBtnIcon
                        colorization: 1.0
                        colorizationColor: window.red
                    }
                }
            }
        }
    }
}
