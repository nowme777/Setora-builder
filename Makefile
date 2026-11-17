ARCHS = arm64
TARGET := iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless
export CLANG_MODULE_CACHE_PATH := $(THEOS_PROJECT_DIR)/.theos/module-cache

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Setora

Setora_FILES = Tweak.x
Setora_CFLAGS = -fobjc-arc -fmodules-cache-path=$(THEOS_PROJECT_DIR)/.theos/module-cache
Setora_FRAMEWORKS = UIKit Foundation
Setora_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += SetoraPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
