# Copyright:
#   Stefan Wagner 2023
#   Bogdan Ionescu 2025

# Files and Folders
TARGET  := firmware
INCLUDE := include
SOURCE  := src
BIN     := bin

# Microcontroller Settings
F_CPU   := 24000000
MODEL   := py32f002bx5
LDSCRIPT:= ld/$(MODEL).ld
CPUARCH := -mcpu=cortex-m0plus -mthumb

# Toolchain
PREFIX  := arm-none-eabi
CC      := $(PREFIX)-gcc
OBJCOPY := $(PREFIX)-objcopy
OBJDUMP := $(PREFIX)-objdump
OBJSIZE := $(PREFIX)-size

# Compiler Flags
CFLAGS  := -g -Os -flto $(CPUARCH) -DF_CPU=$(F_CPU) -I$(INCLUDE) -I$(SOURCE) -I.
CFLAGS  += -fdata-sections -ffunction-sections -fno-builtin -fno-common -Wall -D$(MODEL)
LDFLAGS := -T$(LDSCRIPT) #-static -lc -lm -nostartfiles -nostdlib -lgcc
LDFLAGS += -Wl,--gc-sections,--build-id=none --specs=nano.specs --specs=nosys.specs -Wl,--print-memory-usage
CFILES  := $(wildcard ./*.c) $(wildcard $(SOURCE)/*.c) $(wildcard $(SOURCE)/*.S)

all:	$(BIN)/$(TARGET).lst $(BIN)/$(TARGET).map $(BIN)/$(TARGET).bin $(BIN)/$(TARGET).hex $(BIN)/$(TARGET).asm

$(BIN):
	@mkdir -p $(BIN)

$(BIN)/$(TARGET).elf: $(CFILES)
	@echo "Building $(BIN)/$(TARGET).elf ..."
	@mkdir -p $(BIN)
	@$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

$(BIN)/$(TARGET).lst: $(BIN)/$(TARGET).elf
	@echo "Building $(BIN)/$(TARGET).lst ..."
	@$(OBJDUMP) -S $^ > $(BIN)/$(TARGET).lst

$(BIN)/$(TARGET).map: $(BIN)/$(TARGET).elf
	@echo "Building $(BIN)/$(TARGET).map ..."
	@$(OBJDUMP) -t $^ > $(BIN)/$(TARGET).map

$(BIN)/$(TARGET).bin: $(BIN)/$(TARGET).elf
	@echo "Building $(BIN)/$(TARGET).bin ..."
	@$(OBJCOPY) -O binary $< $(BIN)/$(TARGET).bin

$(BIN)/$(TARGET).hex: $(BIN)/$(TARGET).elf
	@echo "Building $(BIN)/$(TARGET).hex ..."
	@$(OBJCOPY) -O ihex $< $(BIN)/$(TARGET).hex

$(BIN)/$(TARGET).asm: $(BIN)/$(TARGET).elf
	@echo "Disassembling to $(BIN)/$(TARGET).asm ..."
	@$(OBJDUMP) -d $(BIN)/$(TARGET).elf > $(BIN)/$(TARGET).asm


$(BIN)/$(TARGET)_dump.bin:
	pyocd cmd -t $(MODEL) -f 1m -c reset halt -c savemem 0x08000000 0x6000 $(BIN)/$(TARGET)_dump.bin

elf:	$(BIN)/$(TARGET).elf

bin:	$(BIN)/$(TARGET).bin

hex:	$(BIN)/$(TARGET).hex

asm:	$(BIN)/$(TARGET).asm

dump: $(BIN)/$(TARGET)_dump.bin

flash:	$(BIN)/$(TARGET).bin
	@echo "Uploading to MCU ..."
	@pyocd load -t $(MODEL) -f 1m $(BIN)/$(TARGET).bin

connect:
	@pyocd gdb -S -O semihost_console_type=console -t py32f030x4 -f 1m --elf $(BIN)/$(TARGET).elf


monitor:
	@$(PREFIX)-gdb $(BIN)/$(TARGET).elf -ex="c" &
	@pyocd gdb -S -O semihost_console_type=console -t py32f030x4 -f 1m --elf $(BIN)/$(TARGET).elf


debug:
	@$(PREFIX)-gdb $(BIN)/$(TARGET).elf 

clean:
	@echo "Cleaning all up ..."
	rm -rf $(BIN)

