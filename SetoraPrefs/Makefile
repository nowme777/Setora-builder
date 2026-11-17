ARCHS = arm64
TARGET := iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SetoraPrefs

SetoraPrefs_FILES = STRRootListController.m
SetoraPrefs_FRAMEWORKS = UIKit
SetoraPrefs_PRIVATE_FRAMEWORKS = Preferences
SetoraPrefs_INSTALL_PATH = /Library/PreferenceBundles
SetoraPrefs_CFLAGS = -fobjc-arc -fmodules-cache-path=$(THEOS_PROJECT_DIR)/.theos/module-cache

include $(THEOS_MAKE_PATH)/bundle.mk
