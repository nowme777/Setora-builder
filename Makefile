ARCHS = arm64 arm64e
TARGET := iphone:clang:15.6:15.0
THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Setora

Setora_FILES = Tweak.x
Setora_CFLAGS = -fobjc-arc
Setora_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
