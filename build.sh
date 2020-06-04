#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
ZIP_FILE_VERSION="$(date +%d%m%y-%H%M)"
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SRC_LIST="META-INF"

setFailed() {
  if [[ "$?" != 0 ]]; then
    if [[ -n "$1" ]]; then
      echo -e "${RED}[x]${NC} $1" >&2
      cd "$OLDPWD"
      exit 1
    fi
  fi
}

setWarning() {
  if [[ "$?" != 0 ]]; then
    if [[ -n "$1" ]]; then
      echo -e "${RED}[x]${NC} $1" >&2
      cd "$OLDPWD"
    fi
  fi
}

print() {
  echo -e "${NC}[-] $1"
}

setSuccessful() {
  echo -e "${GREEN}[\xE2\x9C\x94]${NC} $1"
}

if ! [ -x "$(command -v zip)" ]; then
  echo -e "${RED}[x]${NC} zip is not found." >&2
  exit 1
fi

if [[ -d "$SRC_DIR/apps" ]]; then
  SRC_LIST="$SRC_LIST apps"
fi

if [[ -d "$SRC_DIR/config" ]]; then
  SRC_LIST="$SRC_LIST config"
fi

if [[ -d "$SRC_DIR/system" ]]; then
  SRC_LIST="$SRC_LIST system"
fi

if [[ -d "$SRC_DIR/vendor" ]]; then
  SRC_LIST="$SRC_LIST vendor"
fi

print "Creating new flashable zip. It may take a few minutes.."
mkdir -p "$SRC_DIR/out"
cd "$SRC_DIR"
zip -6qrX "$SRC_DIR/out/Aerial-Mod-$ZIP_FILE_VERSION.zip" $SRC_LIST
setFailed "Something went wrong. Try again."
print "$SRC_DIR/out/Aerial-Mod-$ZIP_FILE_VERSION.zip"
setSuccessful "Flashable zip created successfully."
cd "$OLDPWD"
