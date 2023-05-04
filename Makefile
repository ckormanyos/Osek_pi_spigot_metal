# ******************************************************************************************
#   Filename    : Makefile
#
#   Author      : Chalandi Amine
#
#   Owner       : Chalandi Amine
#
#   Date        : 22.11.2022
#
#   Description : Build system
#
# ******************************************************************************************

############################################################################################
# Defines
############################################################################################

HW_TARGET  = pi_spigot_metal
PRJ_NAME   = Osek_$(HW_TARGET)
OUTPUT_DIR = $(CURDIR)/Output
OBJ_DIR    = $(CURDIR)/Tmp/Obj
SRC_DIR    = $(CURDIR)

CC_ERR_FORMAT_SCRIPT = CompilerErrorFormater.py
LD_SCRIPT            = $(SRC_DIR)/Startup/Memory_Map.ld
############################################################################################
# Toolchain
############################################################################################

AS      = arm-none-eabi-g++
CC      = arm-none-eabi-g++
CPP     = arm-none-eabi-g++
CPPFILT = arm-none-eabi-c++filt
LD      = arm-none-eabi-g++
NM      = arm-none-eabi-nm
OBJDUMP = arm-none-eabi-objdump
OBJCOPY = arm-none-eabi-objcopy
READELF = arm-none-eabi-readelf
PYTHON  = python
############################################################################################
# C Compiler flags
############################################################################################

OPS_BASE     = -Wall                                          \
               -Wextra                                        \
               -Wpedantic                                     \
               -Wno-variadic-macros                           \
               -O2                                            \
               -marm                                          \
               -march=armv6zk                                 \
               -mtune=arm1176jzf-s                            \
               -mfpu=vfpv2                                    \
               -mfloat-abi=hard                               \
               -fomit-frame-pointer                           \
               -fno-exceptions                                \
               -fno-inline-functions                          \
               -gdwarf-2

COPS         = -x c                                           \
               $(OPS_BASE)                                    \
               -std=c99

############################################################################################
# C++ Compiler flags
############################################################################################

CPPOPS       = -x c++                                         \
               $(OPS_BASE)                                    \
               -std=c++14                                     \
               -fno-rtti                                      \
               -fno-use-cxa-atexit                            \
               -fno-nonansi-builtins                          \
               -fno-threadsafe-statics                        \
               -Wzero-as-null-pointer-constant

############################################################################################
# Assembler flags
############################################################################################

ASOPS        = -x assembler                                   \
               $(OPS_BASE)

############################################################################################
# Linker flags
############################################################################################

LOPS         = -x none                                        \
               -nostartfiles                                  \
               -nostdlib                                      \
               -specs=nano.specs                              \
               -specs=nosys.specs                             \
               $(OPS_BASE)                                    \
               -e reset                                       \
               -Wl,--print-memory-usage                       \
               -Wl,-Map,$(OUTPUT_DIR)/$(PRJ_NAME).map         \
               -T $(LD_SCRIPT)


############################################################################################
# Source Files
############################################################################################

SRC_FILES :=  $(SRC_DIR)/Appli/main                                                   \
              $(SRC_DIR)/Appli/tasks                                                  \
              $(SRC_DIR)/Appli/pi_spigot/pi_spigot                                    \
              $(SRC_DIR)/Mcal/gpio/gpio                                               \
              $(SRC_DIR)/Mcal/gpt/gpt                                                 \
              $(SRC_DIR)/Mcal/mcu/mcu                                                 \
              $(SRC_DIR)/Mcal/pwr/pwr                                                 \
              $(SRC_DIR)/Mcal/systimer/systimer                                       \
              $(SRC_DIR)/Osek/OS                                                      \
              $(SRC_DIR)/Osek/OsAlarm                                                 \
              $(SRC_DIR)/Osek/OsEvt                                                   \
              $(SRC_DIR)/Osek/OsTask                                                  \
              $(SRC_DIR)/Osek/TCB                                                     \
              $(SRC_DIR)/Osek/HwPlatform/ARM11/OsAsm                                  \
              $(SRC_DIR)/ref_app/src/mcal/mcal                                        \
              $(SRC_DIR)/ref_app/src/mcal/mcal_gcc_cxx_completion_with_stdlib         \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_cpu                    \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_cpu_detail             \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_cpu_detail_secure      \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_gpt                    \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_irq                    \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_lcd                    \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_led                    \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_port                   \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b/mcal_spi                    \
              $(SRC_DIR)/Startup/Exceptions                                           \
              $(SRC_DIR)/Startup/IntVectTable                                         \
              $(SRC_DIR)/Startup/Startup                                              \

############################################################################################
# Include Paths
############################################################################################
INC_FILES :=  $(SRC_DIR)/Appli/pi_spigot                               \
              $(SRC_DIR)/ref_app/src                                   \
              $(SRC_DIR)/ref_app/src/mcal/bcm2835_raspi_b              \
              $(SRC_DIR)/Osek                                          \
              $(SRC_DIR)/Osek/HwPlatform/ARM11                         \
              $(SRC_DIR)/Mcal/gpio                                     \
              $(SRC_DIR)/Mcal/gpt                                      \
              $(SRC_DIR)/Mcal/mcu                                      \
              $(SRC_DIR)/Std

############################################################################################
# Rules
############################################################################################

VPATH := $(subst \,/,$(sort $(dir $(SRC_FILES)) $(OBJ_DIR)))

FILES_O := $(addprefix $(OBJ_DIR)/, $(notdir $(addsuffix .o, $(SRC_FILES))))


ifeq ($(MAKECMDGOALS),build)
-include $(subst .o,.d,$(FILES_O))
endif

build : clean $(OUTPUT_DIR)/$(PRJ_NAME).elf

all : clean $(OUTPUT_DIR)/$(PRJ_NAME).elf


.PHONY : clean
clean :
	@-rm -rf $(OBJ_DIR) *.o       2>/dev/null || true
	@-rm -rf $(OBJ_DIR) *.err     2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.hex  2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.elf  2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.list 2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.map  2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.txt  2>/dev/null || true
	@-mkdir -p $(OBJ_DIR)
	@-mkdir -p $(OUTPUT_DIR)

$(OBJ_DIR)/%.o : %.c
	@-echo +++ compile: $(subst \,/,$<) to $(subst \,/,$@)
	@-$(CC) $(COPS) $(addprefix -I, $(INC_FILES)) -c $< -o $(OBJ_DIR)/$(basename $(@F)).o 2> $(OBJ_DIR)/$(basename $(@F)).err
	@-$(PYTHON) $(CC_ERR_FORMAT_SCRIPT) $(OBJ_DIR)/$(basename $(@F)).err -COLOR

$(OBJ_DIR)/%.o : %.s
	@-echo +++ compile: $(subst \,/,$<) to $(subst \,/,$@)
	@$(AS) $(ASOPS) -c $< -o $(OBJ_DIR)/$(basename $(@F)).o 2> $(OBJ_DIR)/$(basename $(@F)).err >$(OBJ_DIR)/$(basename $(@F)).lst
	@-$(PYTHON) $(CC_ERR_FORMAT_SCRIPT) $(OBJ_DIR)/$(basename $(@F)).err -COLOR

$(OBJ_DIR)/%.o : %.cpp
	@-echo +++ compile: $(subst \,/,$<) to $(subst \,/,$@)
	@$(CPP) $(CPPOPS) $(addprefix -I, $(INC_FILES)) -c $< -o $(OBJ_DIR)/$(basename $(@F)).o 2> $(OBJ_DIR)/$(basename $(@F)).err
	@-$(PYTHON) $(CC_ERR_FORMAT_SCRIPT) $(OBJ_DIR)/$(basename $(@F)).err -COLOR

$(OUTPUT_DIR)/$(PRJ_NAME).elf : $(FILES_O)
	@$(LD) $(LOPS) $(FILES_O) -o $(OUTPUT_DIR)/$(PRJ_NAME).elf
	@$(OBJCOPY) $(OUTPUT_DIR)/$(PRJ_NAME).elf -O ihex $(OUTPUT_DIR)/$(PRJ_NAME).hex
	@$(OBJCOPY) $(OUTPUT_DIR)/$(PRJ_NAME).elf -O binary $(OUTPUT_DIR)/kernel.img
	@$(NM) --numeric-sort --print-size $(OUTPUT_DIR)/$(PRJ_NAME).elf | $(CPPFILT) > $(OUTPUT_DIR)/$(PRJ_NAME)_cppfilt.txt
