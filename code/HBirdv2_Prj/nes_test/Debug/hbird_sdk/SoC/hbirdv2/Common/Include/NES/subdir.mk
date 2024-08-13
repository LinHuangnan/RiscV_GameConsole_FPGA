################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/ILI93xx.c \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_system.c \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/rom.c 

CPP_SRCS += \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES.cpp \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_Mapper.cpp \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_pAPU.cpp \
../hbird_sdk/SoC/hbirdv2/Common/Include/NES/K6502.cpp 

OBJS += \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/ILI93xx.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_Mapper.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_pAPU.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_system.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/K6502.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/rom.o 

C_DEPS += \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/ILI93xx.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_system.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/rom.d 

CPP_DEPS += \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_Mapper.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/InfoNES_pAPU.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/NES/K6502.d 


# Each subdirectory must supply rules for building sources it contributes
hbird_sdk/SoC/hbirdv2/Common/Include/NES/%.o: ../hbird_sdk/SoC/hbirdv2/Common/Include/NES/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-nuclei-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -mno-save-restore -O2 -ffunction-sections -fdata-sections -fno-common --specs=nano.specs --specs=nosys.specs  -g -D__IDE_RV_CORE=e203 -DSOC_HBIRD -DDOWNLOAD_MODE=DOWNLOAD_MODE_ILM -DDOWNLOAD_MODE_STRING=\"ILM\" -DBOARD_DDR200T -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\NMSIS\Core\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Common\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Board\ddr200t\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\application" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

hbird_sdk/SoC/hbirdv2/Common/Include/NES/%.o: ../hbird_sdk/SoC/hbirdv2/Common/Include/NES/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C++ Compiler'
	riscv-nuclei-elf-g++ -march=rv32imac -mabi=ilp32 -mcmodel=medany -mno-save-restore -O2 -ffunction-sections -fdata-sections -fno-common --specs=nano.specs --specs=nosys.specs  -g -D__IDE_RV_CORE=e203 -DSOC_HBIRD -DDOWNLOAD_MODE=DOWNLOAD_MODE_ILM -DDOWNLOAD_MODE_STRING=\"ILM\" -DBOARD_DDR200T -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\NMSIS\Core\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Common\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Board\ddr200t\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\application" -std=gnu++11 -fabi-version=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


