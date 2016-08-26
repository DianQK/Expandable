#!/bin/sh

if ! which xcodebuild >/dev/null; then
  echo "xcodebuild is not available. Install it from https://itunes.apple.com/us/app/xcode/id497799835"
  exit 1
fi

if ! which carthage >/dev/null; then
  echo "installing carthage..."
  brew update
  brew install carthage
fi

if which carthage >/dev/null; then
  echo "installing carthage dependence..."
  carthage bootstrap --verbose --platform ios --color auto --no-use-binaries
fi
