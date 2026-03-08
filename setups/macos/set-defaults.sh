#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false



###############################################################################
# General UI/UX                                                               #
###############################################################################
# Disable the sound effects on boot
sudo nvram StartupMute=%01

# Move windows by dragging any part of the window
defaults write -g NSWindowShouldDragOnGesture -bool true

# Disable windows opening animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
