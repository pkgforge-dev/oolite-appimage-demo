#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q oolite | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/oolite/Resources/Textures/oolite-logo1.png
export DESKTOP=/usr/share/applications/oolite.desktop
export DEPLOY_OPENGL=1
export DEPLOY_SDL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/oolite /usr/share/espeak-ng-data

echo '#!/bin/false
mkdir -p ~/.Oolite/AddOns ~/GNUstep/Library/ApplicationSupport/Oolite/ManagedAddOns
ESPEAK_DATA_PATH=$APPDIR/share/espeak-ng-data
export ESPEAK_DATA_PATH
' > ./AppDir/bin/oolite-pre-launch.src.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
