// fede.lock — LockView
//
// Minimal-monument redesign of the session lock. One left-aligned column:
// an oversized SF Pro Display clock, a short accent hairline, the date set
// small in tracked uppercase, then — across a deliberate band of empty
// space — a borderless password field that is nothing but an underline.
// No card, no glass, no glow; the weight comes from scale and negative
// space alone.
//
// The fixed wallpaper (~/.config/hypr/imgs/wallpaper.jpg) is kept but
// graded down toward the theme background and layered with a
// left-to-right scrim, a bottom-up scrim and a top vignette, so the
// column always has ground to sit on no matter what the photo shows.
//
// Every dimension is a fraction of the surface, so the composition holds
// at any resolution. The password-field mechanics (PAM signals via
// Service.qml, the fingerprint hint, wake-on-input) are unchanged from
// the stock omarchy.lock this was cloned from: Service.qml depends on the
// root properties, signals and functions below, on the `passwordInput`
// item, and on the objectName "fingerprintIndicator". The previous
// version is saved next to this file as LockView.qml.bak.<timestamp>.

import QtQuick
import QtQuick.Effects
import Quickshell
import qs.Commons

Item {
  id: root

  property string backgroundPath: ""
  property int backgroundVersion: 0
  property bool fingerprintConfigured: false
  property bool authenticatingPassword: false
  property string failureMessage: ""
  property int failedAttempts: 0
  property bool inputEnabled: true
  property bool loadBackground: true
  property string passwordText: ""
  property bool syncingPasswordText: false

  readonly property string placeholderText: "Enter password"

  // ---- Composition, sized as a fraction of the surface ----
  readonly property int clockFontSize: Math.max(32, Math.round(height * 0.152))
  readonly property int dateFontSize: Math.max(12, Math.round(height * 0.0135))
  readonly property int nameFontSize: Math.max(11, Math.round(height * 0.0125))
  readonly property int fieldFontSize: Math.round(Style.font.heading * 1.05)
  readonly property int passwordDotFontSize: Math.round(Style.font.heading * 1.18)
  readonly property int passwordDotLetterSpacing: Math.round(Style.font.heading * 0.16)
  readonly property int columnLeft: Math.max(40, Math.round(width * 0.085))
  readonly property int fieldWidth: Math.max(300, Math.round(width * 0.23))
  readonly property int ruleWidth: Math.max(48, Math.round(height * 0.088))
  readonly property int ruleHeight: Math.max(2, Math.round(height * 0.0025))

  readonly property bool errorState: failureMessage.length > 0
  readonly property color primaryText: Color.foreground
  readonly property color accentLine: Color.accent
  readonly property color errorInk: Color.urgent
  // Neutral ink for the background grading. Deliberately not the theme
  // background (that reads as a blue cast on the left); the only themed
  // color on this surface is the accent hairline.
  readonly property color scrimInk: "#0a0a0b"

  // Driven by shakeAnim on a failed attempt.
  property real shakeOffset: 0

  signal submitPassword(string password)
  signal passwordTextEdited(string password)
  signal clearFailureRequested()
  signal wakeRequested()

  // Cache-busts the lock background by appending `?v=`. Kept for API
  // parity with the stock LockView even though this design uses a fixed
  // wallpaper path below.
  function fileUrl(path) {
    if (!path) return ""
    var encoded = String(path).split("/").map(encodeURIComponent).join("/")
    return "file://" + encoded + "?v=" + backgroundVersion
  }

  function forcePasswordFocus() {
    passwordInput.forceActiveFocus()
  }

  function clearPassword() {
    passwordTextEdited("")
  }

  function syncPasswordText() {
    if (passwordInput.text === passwordText) return
    syncingPasswordText = true
    passwordInput.text = passwordText
    syncingPasswordText = false
  }

  onPasswordTextChanged: syncPasswordText()
  onInputEnabledChanged: {
    if (inputEnabled) Qt.callLater(forcePasswordFocus)
  }
  onErrorStateChanged: {
    if (errorState) shakeAnim.restart()
  }
  onFailedAttemptsChanged: {
    if (failedAttempts > 0) shakeAnim.restart()
  }
  Component.onCompleted: {
    syncPasswordText()
    if (inputEnabled) Qt.callLater(forcePasswordFocus)
  }

  Timer {
    id: clockTimer
    property date now: new Date()
    interval: 1000
    running: true
    repeat: true
    onTriggered: now = new Date()
  }

  // Short horizontal jolt when a password is rejected.
  SequentialAnimation {
    id: shakeAnim
    running: false
    NumberAnimation { target: root; property: "shakeOffset"; to: -10; duration: 55; easing.type: Easing.OutQuad }
    NumberAnimation { target: root; property: "shakeOffset"; to:  10; duration: 55; easing.type: Easing.InOutQuad }
    NumberAnimation { target: root; property: "shakeOffset"; to:  -6; duration: 50; easing.type: Easing.InOutQuad }
    NumberAnimation { target: root; property: "shakeOffset"; to:   4; duration: 50; easing.type: Easing.InOutQuad }
    NumberAnimation { target: root; property: "shakeOffset"; to:   0; duration: 45; easing.type: Easing.InQuad }
  }

  Rectangle {
    anchors.fill: parent
    color: Color.background

    Image {
      id: wallpaper
      anchors.fill: parent
      source: root.loadBackground
        ? "file://" + Quickshell.env("HOME") + "/.config/hypr/imgs/wallpaper.jpg"
        : ""
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
    }

    // Grade the photo toward the theme background: dimmer, flatter, less
    // saturated. No blur — the picture is meant to read, only quietly.
    MultiEffect {
      anchors.fill: wallpaper
      source: wallpaper
      autoPaddingEnabled: false
      blurEnabled: false
      brightness: -0.20
      contrast: -0.05
      saturation: -0.16
    }

    // Light whole-frame wash. Kept subtle so the stacked scrims below
    // don't band on near-black values.
    Rectangle {
      anchors.fill: parent
      color: Util.alpha(root.scrimInk, 0.12)
    }

    // Left-to-right scrim: ground for the left-aligned column, carried far
    // enough right to veil the photo's bright spot.
    Rectangle {
      anchors.fill: parent
      gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0;  color: Util.alpha(root.scrimInk, 0.76) }
        GradientStop { position: 0.40; color: Util.alpha(root.scrimInk, 0.38) }
        GradientStop { position: 0.85; color: "transparent" }
      }
    }

    // Right-edge scrim: closes the frame on the empty side.
    Rectangle {
      anchors.fill: parent
      gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.62; color: "transparent" }
        GradientStop { position: 1.0;  color: Util.alpha(root.scrimInk, 0.32) }
      }
    }

    // Vertical vignette: darker at top and bottom, clearest through the
    // band the column occupies.
    Rectangle {
      anchors.fill: parent
      gradient: Gradient {
        GradientStop { position: 0.0;  color: Util.alpha(root.scrimInk, 0.30) }
        GradientStop { position: 0.34; color: "transparent" }
        GradientStop { position: 0.72; color: "transparent" }
        GradientStop { position: 1.0;  color: Util.alpha(root.scrimInk, 0.44) }
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: { root.wakeRequested(); root.forcePasswordFocus() }
      onPositionChanged: root.wakeRequested()
    }

    // ---- The monument ----
    Column {
      id: stack
      anchors.left: parent.left
      anchors.leftMargin: root.columnLeft
      anchors.verticalCenter: parent.verticalCenter
      anchors.verticalCenterOffset: Math.round(parent.height * 0.005)
      spacing: 0

      Item {
        id: clockGroup
        width: clockText.width
        height: clockText.height
        opacity: 0
        transform: Translate { id: clockShift; y: 18 }

        Text {
          id: clockText
          text: Qt.formatDateTime(clockTimer.now, "HH:mm")
          color: root.primaryText
          font.family: "SF Pro Display"
          font.styleName: "Regular"
          font.pixelSize: root.clockFontSize
          font.letterSpacing: -Math.round(root.clockFontSize * 0.03)
          style: Text.Raised
          styleColor: Qt.rgba(0, 0, 0, 0.18)
        }
      }

      Item { width: 1; height: Math.round(root.height * 0.020) }

      Rectangle {
        id: rule
        width: root.ruleWidth
        height: root.ruleHeight
        color: root.accentLine
        opacity: 0
        transform: Translate { id: ruleShift; y: 18 }
      }

      Item { width: 1; height: Math.round(root.height * 0.018) }

      Text {
        id: dateText
        text: Qt.formatDateTime(clockTimer.now, "dddd, MMMM d")
        color: Util.alpha(root.primaryText, 0.72)
        font.family: "SF Pro Display"
        font.styleName: "Bold"
        font.pixelSize: root.dateFontSize
        font.letterSpacing: Math.round(root.dateFontSize * 0.26)
        font.capitalization: Font.AllUppercase
        opacity: 0
        transform: Translate { id: dateShift; y: 18 }
      }

      Item { width: 1; height: Math.round(root.height * 0.105) }

      // ---- Password field: an underline, nothing more ----
      Item {
        id: fieldGroup
        width: root.fieldWidth
        height: Math.round(root.fieldFontSize * 2.3)
        opacity: 0
        transform: [
          Translate { id: fieldShift; y: 18 },
          Translate { x: root.shakeOffset }
        ]

        TextInput {
          id: passwordInput
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: underline.top
          anchors.bottomMargin: 8
          anchors.rightMargin: root.fingerprintConfigured ? Math.round(fingerprintIcon.implicitWidth + 16) : 0
          verticalAlignment: TextInput.AlignVCenter
          horizontalAlignment: TextInput.AlignLeft
          activeFocusOnPress: true
          clip: true
          enabled: root.inputEnabled && !root.authenticatingPassword
          readOnly: root.authenticatingPassword
          echoMode: TextInput.Password
          passwordCharacter: "●"
          passwordMaskDelay: 0
          color: root.primaryText
          selectionColor: Util.alpha(root.accentLine, 0.35)
          selectedTextColor: root.primaryText
          font.family: "SF Pro Display"
          font.styleName: "Regular"
          font.pixelSize: text.length > 0 ? root.passwordDotFontSize : root.fieldFontSize
          font.letterSpacing: text.length > 0 ? root.passwordDotLetterSpacing : 0.5
          cursorVisible: activeFocus && root.inputEnabled && !root.authenticatingPassword && !root.errorState && text.length > 0
          cursorDelegate: Rectangle {
            width: 2
            color: root.accentLine
            visible: passwordInput.cursorVisible
          }

          onTextChanged: {
            if (!root.syncingPasswordText) root.passwordTextEdited(text)
            if (text.length > 0) root.wakeRequested()
            if (text.length > 0 && root.failureMessage.length > 0) root.clearFailureRequested()
          }

          onAccepted: {
            var submitted = root.passwordText
            root.passwordTextEdited("")
            if (submitted.length > 0) root.submitPassword(submitted)
          }

          Keys.onPressed: function(event) {
            root.wakeRequested()
            if (event.key === Qt.Key_Escape || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_U)) {
              root.passwordTextEdited("")
              event.accepted = true
            }
          }
        }

        // Placeholder / status line, shown while the field is empty.
        Text {
          anchors.fill: passwordInput
          text: root.authenticatingPassword
            ? "Checking…"
            : (root.errorState ? root.failureMessage : root.placeholderText)
          visible: passwordInput.text.length === 0
          color: root.authenticatingPassword
            ? Util.alpha(root.primaryText, 0.82)
            : (root.errorState ? root.errorInk : Util.alpha(root.primaryText, 0.68))
          font.family: "SF Pro Display"
          font.styleName: "Regular"
          font.pixelSize: root.fieldFontSize
          font.letterSpacing: 0.5
          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter
          elide: Text.ElideRight
        }

        // Fingerprint hint, pinned to the field's right edge when a
        // sensor is enrolled. objectName kept for Service.qml lookups.
        Text {
          id: fingerprintIcon
          objectName: "fingerprintIndicator"
          anchors.right: parent.right
          anchors.verticalCenter: passwordInput.verticalCenter
          visible: root.fingerprintConfigured
          text: "󰈷"
          color: Util.alpha(root.primaryText, 0.55)
          font.family: Style.font.family
          font.pixelSize: Math.round(root.fieldFontSize * 1.15)
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        // The whole field: one rule. Thickens and turns accent on focus,
        // turns to the error ink when a password is rejected.
        Rectangle {
          id: underline
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          height: passwordInput.activeFocus || root.errorState ? 2 : 1
          color: root.errorState
            ? root.errorInk
            : (passwordInput.activeFocus ? root.accentLine : Util.alpha(root.primaryText, 0.40))
          Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
          Behavior on color { ColorAnimation { duration: 150 } }

          // Quiet pulse along the rule while a check is in flight.
          Rectangle {
            anchors.fill: parent
            color: root.accentLine
            visible: root.authenticatingPassword
            opacity: 0
            SequentialAnimation on opacity {
              running: root.authenticatingPassword
              loops: Animation.Infinite
              NumberAnimation { to: 0.9; duration: 550; easing.type: Easing.InOutSine }
              NumberAnimation { to: 0.15; duration: 550; easing.type: Easing.InOutSine }
            }
          }
        }
      }

      Item { width: 1; height: Math.round(root.height * 0.020) }

      Text {
        id: nameText
        text: Quickshell.env("USER") || Quickshell.env("LOGNAME") || ""
        color: Util.alpha(root.primaryText, 0.56)
        font.family: "SF Pro Display"
        font.styleName: "Regular"
        font.pixelSize: root.nameFontSize
        font.letterSpacing: Math.round(root.nameFontSize * 0.12)
        opacity: 0
        transform: Translate { id: nameShift; y: 18 }
      }
    }
  }

  // ---- One authored entrance: the column settles in, lightly staggered ----
  SequentialAnimation {
    running: true
    PauseAnimation { duration: 40 }
    ParallelAnimation {
      NumberAnimation { target: clockGroup; property: "opacity"; to: 1; duration: 440; easing.type: Easing.OutExpo }
      NumberAnimation { target: clockShift; property: "y"; to: 0; duration: 620; easing.type: Easing.OutExpo }
    }
  }
  SequentialAnimation {
    running: true
    PauseAnimation { duration: 115 }
    ParallelAnimation {
      NumberAnimation { target: rule; property: "opacity"; to: 1; duration: 440; easing.type: Easing.OutExpo }
      NumberAnimation { target: ruleShift; property: "y"; to: 0; duration: 620; easing.type: Easing.OutExpo }
      NumberAnimation { target: dateText; property: "opacity"; to: 1; duration: 440; easing.type: Easing.OutExpo }
      NumberAnimation { target: dateShift; property: "y"; to: 0; duration: 620; easing.type: Easing.OutExpo }
    }
  }
  SequentialAnimation {
    running: true
    PauseAnimation { duration: 195 }
    ParallelAnimation {
      NumberAnimation { target: fieldGroup; property: "opacity"; to: 1; duration: 460; easing.type: Easing.OutExpo }
      NumberAnimation { target: fieldShift; property: "y"; to: 0; duration: 640; easing.type: Easing.OutExpo }
      NumberAnimation { target: nameText; property: "opacity"; to: 1; duration: 460; easing.type: Easing.OutExpo }
      NumberAnimation { target: nameShift; property: "y"; to: 0; duration: 640; easing.type: Easing.OutExpo }
    }
  }
}
