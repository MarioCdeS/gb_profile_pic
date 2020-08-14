ASM = rgbasm
LINK = rgblink
FIX = rgbfix

TARGET = gb_profile_pic.gb

RGBDS_INCLUDE_PATH := $(abspath $(addsuffix ../include/,$(dir $(shell which $(ASM)))))
INCLUDE_PATH := include
SOURCE_PATH := src
OBJ_PATH := obj
ASSETS_PATH := assets

INCLUDE_FILES := $(wildcard $(INCLUDE_PATH)/*.inc)
SOURCE_FILES := $(wildcard $(SOURCE_PATH)/*.asm)
OBJ_FILES := $(patsubst $(SOURCE_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SOURCE_FILES))
ASSET_FILES := $(wildcard $(ASSETS_PATH)/*.bin)

.PHONY: clean fix

$(TARGET): $(OBJ_FILES)
	$(LINK) -o $@ $(OBJ_FILES)

$(OBJ_PATH)/%.o: $(SOURCE_PATH)/%.asm $(INCLUDE_FILES) $(ASSET_FILES) $(OBJ_PATH) 
	$(ASM) -i $(RGBDS_INCLUDE_PATH) -i $(INCLUDE_PATH) -o $@ $<

$(OBJ_PATH):
	mkdir $(OBJ_PATH)

clean:
	rm -rf $(OBJ_PATH)

fix:
	$(FIX) -p 0 -v $(TARGET)
