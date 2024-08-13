################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_system.c 

CPP_SRCS += \
../hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES.cpp \
../hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_Mapper.cpp \
../hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_pAPU.cpp \
../hbird_sdk/SoC/hbirdv2/Common/Include/K6502.cpp 

OBJS += \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_Mapper.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_pAPU.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_system.o \
./hbird_sdk/SoC/hbirdv2/Common/Include/K6502.o 

C_DEPS += \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_system.d 

CPP_DEPS += \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_Mapper.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/InfoNES_pAPU.d \
./hbird_sdk/SoC/hbirdv2/Common/Include/K6502.d 


# Each subdirectory must supply rules for building sources it contributes
hbird_sdk/SoC/hbirdv2/Common/Include/%.o: ../hbird_sdk/SoC/hbirdv2/Common/Include/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C++ Compiler'
	riscv-nuclei-elf-g++ -march=rv32imac -mabi=ilp32 -mcmodel=medany -mno-save-restore -O2 -ffunction-sections -fdata-sections -fno-common --specs=nano.specs --specs=nosys.specs  -g -D__IDE_RV_CORE=e203 -DSOC_HBIRD -DDOWNLOAD_MODE=DOWNLOAD_MODE_ILM -DDOWNLOAD_MODE_STRING=\"ILM\" -DBOARD_DDR200T -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\NMSIS\Core\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Common\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Board\ddr200t\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\application" -std=gnu++11 -fabi-version=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

hbird_sdk/SoC/hbirdv2/Common/Include/%.o: ../hbird_sdk/SoC/hbirdv2/Common/Include/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-nuclei-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -mno-save-restore -O2 -ffunction-sections -fdata-sections -fno-common --specs=nano.specs --specs=nosys.specs  -g -D__IDE_RV_CORE=e203 -DSOC_HBIRD -DDOWNLOAD_MODE=DOWNLOAD_MODE_ILM -DDOWNLOAD_MODE_STRING=\"ILM\" -DBOARD_DDR200T -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\NMSIS\Core\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Common\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Board\ddr200t\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\application" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


