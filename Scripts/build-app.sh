#!/usr/bin/env bash
# Build NeonPod.app — a proper macOS .app bundle containing the executable
# plus the MediaRemoteAdapter framework and the perl shim.
set -euo pipefail
cd "$(dirname "$0")/.."

CONFIG="${CONFIG:-release}"
APP_NAME="NeonPod"
EXECUTABLE_NAME="MacPod"  # Swift Package target remains named MacPod
APP_DIR="build/${APP_NAME}.app"

echo "==> Building Swift executable (${CONFIG})"
swift build -c "${CONFIG}"

BIN_PATH="$(swift build -c "${CONFIG}" --show-bin-path)/${EXECUTABLE_NAME}"
if [ ! -x "${BIN_PATH}" ]; then
    echo "binary not found at ${BIN_PATH}" >&2
    exit 1
fi

echo "==> Assembling ${APP_DIR}"
rm -rf "${APP_DIR}"
mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

cp "${BIN_PATH}" "${APP_DIR}/Contents/MacOS/${EXECUTABLE_NAME}"

cat > "${APP_DIR}/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>NeonPod</string>
    <key>CFBundleDisplayName</key><string>NeonPod — Y2K Edition</string>
    <key>CFBundleExecutable</key><string>MacPod</string>
    <key>CFBundleIdentifier</key><string>dev.neonpod.y2k</string>
    <key>CFBundleVersion</key><string>9</string>
    <key>CFBundleShortVersionString</key><string>0.8.1</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>LSMinimumSystemVersion</key><string>13.0</string>
    <key>LSUIElement</key><true/>
    <key>NSHighResolutionCapable</key><true/>
    <key>CFBundleIconFile</key><string>NeonPod</string>
</dict>
</plist>
PLIST

cp -R Resources/MediaRemoteAdapter.framework "${APP_DIR}/Contents/Resources/"
cp Resources/mediaremote-adapter.pl "${APP_DIR}/Contents/Resources/"

# Restore framework symlinks even if the source folder traveled through a
# Windows ZIP extractor or Git client that flattened symbolic links.
FRAMEWORK="${APP_DIR}/Contents/Resources/MediaRemoteAdapter.framework"
rm -rf "${FRAMEWORK}/MediaRemoteAdapter" "${FRAMEWORK}/Resources" "${FRAMEWORK}/Versions/Current"
ln -s "A" "${FRAMEWORK}/Versions/Current"
ln -s "Versions/Current/MediaRemoteAdapter" "${FRAMEWORK}/MediaRemoteAdapter"
ln -s "Versions/Current/Resources" "${FRAMEWORK}/Resources"

# Generate the actual macOS icon from the custom neon-green icon PNGs.
# iconutil is included with macOS/Xcode Command Line Tools.
# Build the complete macOS iconset from a single 1024px master PNG.
# sips and iconutil are supplied with macOS; neither runs on Windows.
ICONSET="build/NeonPod.iconset"
mkdir -p "${ICONSET}"
for spec in \
    "icon_16x16.png:16" \
    "icon_16x16@2x.png:32" \
    "icon_32x32.png:32" \
    "icon_32x32@2x.png:64" \
    "icon_128x128.png:128" \
    "icon_128x128@2x.png:256" \
    "icon_256x256.png:256" \
    "icon_256x256@2x.png:512" \
    "icon_512x512.png:512" \
    "icon_512x512@2x.png:1024"; do
    name="${spec%%:*}"
    px="${spec##*:}"
    sips -z "${px}" "${px}" Resources/NeonPod-master.png \
        --out "${ICONSET}/${name}" >/dev/null
done
iconutil -c icns "${ICONSET}" -o "${APP_DIR}/Contents/Resources/NeonPod.icns"

echo "==> Ad-hoc codesigning"
codesign --force --deep --sign - "${APP_DIR}/Contents/Resources/MediaRemoteAdapter.framework"
codesign --force --sign - "${APP_DIR}"

echo "==> Done: ${APP_DIR}"
