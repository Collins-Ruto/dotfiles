import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import qs.modules.common.functions

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || Translation.tr("No media")

    Layout.fillHeight: true
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: Appearance.sizes.barHeight

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        onPressed: (event) => {
            if (event.button === Qt.MiddleButton) {
                activePlayer.togglePlaying();
            } else if (event.button === Qt.BackButton) {
                activePlayer.previous();
            } else if (event.button === Qt.ForwardButton || event.button === Qt.RightButton) {
                activePlayer.next();
            } else if (event.button === Qt.LeftButton) {
                GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen
            }
        }
    }

    RowLayout { // Real content
        id: rowLayout

        spacing: 6
        anchors.fill: parent

                // --- EQUALIZER SPECTRUM VISUALIZER ---
        Row {
            id: eqVisualizer
            spacing: 2
            Layout.alignment: Qt.AlignVCenter
            
            // Only animates if a track is actively playing
            readonly property bool isPlaying: activePlayer?.playbackState == MprisPlaybackState.Playing

            Repeater {
                model: 4 // Number of equalizer bars
                delegate: Rectangle {
                    width: 3
                    // Fallback to a tiny 4px dot when music is paused
                    height: eqVisualizer.isPlaying ? 4 : 4
                    color: eqVisualizer.isPlaying ? "#8a71e6" : Appearance.m3colors.m3onSecondaryContainer
                    radius: 1.5
                    anchors.bottom: parent.bottom

                    // Individual loop animations with staggered speeds to simulate a real spectrum
                    SequentialAnimation on height {
                        loops: Animation.Infinite
                        running: eqVisualizer.isPlaying

                        NumberAnimation { 
                            to: [18, 14, 19, 12][index] // Custom max heights for each bar
                            duration: [350, 250, 400, 300][index] // Staggered bounce speeds
                            easing.type: Easing.InOutQuad 
                        }
                        NumberAnimation { 
                            to: 4 
                            duration: [300, 200, 350, 250][index] 
                            easing.type: Easing.InOutQuad 
                        }
                    }
                }
            }
        }


        // --- INFINITE SCROLLING CONTAINER ---
        Item {
            id: textContainer
            visible: Config.options.bar.verbose
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.rightMargin: rowLayout.spacing
            
            implicitWidth: 160 
            clip: true // Masks out the overflow seamlessly

            readonly property string fullMediaText: `${cleanedTitle}${activePlayer?.trackArtist ? ' • ' + activePlayer.trackArtist : ''}`
            readonly property bool isOverflowing: dummyMeasure.implicitWidth > textContainer.width

            // Invisible text label used strictly to safely measure true string width
            StyledText {
                id: dummyMeasure
                text: textContainer.fullMediaText
                visible: false
                elide: Text.ElideNone
            }

            // The moving layout frame carrying both text instances
            Item {
                id: scrollingTrack
                width: dummyMeasure.implicitWidth * 2 + 40 // Total width including a 40px spacer gap
                height: parent.height
                x: 0

                // Trigger or stop loop when text string content modifies
                onWidthChanged: {
                    infiniteAnim.stop();
                    scrollingTrack.x = 0;
                    if (textContainer.isOverflowing) {
                        infiniteAnim.start();
                    }
                }

                Row {
                    spacing: 40 // Gap size between the repeating track labels
                    anchors.verticalCenter: parent.verticalCenter

                    StyledText {
                        text: textContainer.fullMediaText
                        color: activePlayer?.playbackState == MprisPlaybackState.Playing ? "#4CAF50" : "#FFFFFF"
                        elide: Text.ElideNone
                    }

                    // Second copy: only renders if text overflows, generating the endless sequence
                    StyledText {
                        text: textContainer.fullMediaText
                        color: activePlayer?.playbackState == MprisPlaybackState.Playing ? "#4CAF50" : "#FFFFFF"
                        elide: Text.ElideNone
                        visible: textContainer.isOverflowing
                    }
                }

                NumberAnimation on x {
                    id: infiniteAnim
                    loops: Animation.Infinite
                    running: false
                    from: 0
                    // Move left by exactly one full text width + the spacer gap width
                    to: -(dummyMeasure.implicitWidth + 40)
                    // Maintains stable scroll velocity across text lengths
                    duration: (dummyMeasure.implicitWidth + 40) * 25 
                    easing.type: Easing.Linear
                }
            }
        }
    }
}
