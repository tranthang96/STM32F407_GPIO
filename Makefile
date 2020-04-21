######################################
PRO_DIR		:= .
OUTPUT_PATH := $(PRO_DIR)/output
######################################
# target
######################################
TARGET = blink_led

######################################
INC_DIR		:= $(PRO_DIR)/inc
SRC_DIR		:= $(PRO_DIR)/src
LINKER_FILE := $(PRO_DIR)/linker/stm32f407vgt6.ld
STARTUP_CODE := $(PRO_DIR)/startup
######################################
# COMPILER
FREFIX		?= arm-none-eabi-

CC			:= $(FREFIX)gcc
AS			:= $(FREFIX)as
LD			:= $(FREFIX)ld

LINK_TO_FILE 	:= $(OUTPUT_PATH)/main.o $(OUTPUT_PATH)/startup_stm.o


# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# FLAGS
CFLAGS	:= $(MCU) -c -O0 -g -I$(INC_DIR)
ASFLAGS := $(MCU) -c
LD_OPT			:= -T $(LINKER_FILE) -Map $(OUTPUT_PATH)/$(TARGET).map $(FILE_TO_LINK)


$(OUTPUT_PATH)/main.o: $(SRC_DIR)/main.c
	@echo "compiler $(OUTPUT_PATH)/main.c file"
	$(CC) $(CFLAGS) $(SRC_DIR)/main.c -o $(OUTPUT_PATH)/main.o
	
$(OUTPUT_PATH)/startup_stm.o: $(STARTUP_CODE)/startup_stm32f40xx.s
	@echo "compiler $(STARTUP_CODE)/startup_stm32f40xx.s file"
	$(AS) $(ASFLAGS) $(STARTUP_CODE)/startup_stm32f40xx.s -o $(OUTPUT_PATH)/startup_stm.o
	
build: $(FILE_TO_LINK) $(LINKER_FILE)
	@echo "link object files to create new binary image ($(TARGET).elf)"
	$(LD) $(LD_OPT) -o $(OUTPUT_PATH)/$(TARGET).elf
	
clean: 
	@rm -rf $(OUTPUT_PATH)/*




















