################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../InfoNES097JRC1_SDL/HANKER-LM4F232/InfoNES_system.c \
../InfoNES097JRC1_SDL/HANKER-LM4F232/main.c 

OBJS += \
./InfoNES097JRC1_SDL/HANKER-LM4F232/InfoNES_system.o \
./InfoNES097JRC1_SDL/HANKER-LM4F232/main.o 

C_DEPS += \
./InfoNES097JRC1_SDL/HANKER-LM4F232/InfoNES_system.d \
./InfoNES097JRC1_SDL/HANKER-LM4F232/main.d 


# Each subdirectory must supply rules for building sources it contributes
InfoNES097JRC1_SDL/HANKER-LM4F232/%.o: ../InfoNES097JRC1_SDL/HANKER-LM4F232/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-nuclei-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -mno-save-restore -O2 -ffunction-sections -fdata-sections -fno-common --specs=nano.specs --specs=nosys.specs  -g -D__IDE_RV_CORE=e203 -DSOC_HBIRD -DDOWNLOAD_MODE=DOWNLOAD_MODE_ILM -DDOWNLOAD_MODE_STRING=\"ILM\" -DBOARD_DDR200T -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\NMSIS\Core\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Common\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\hbird_sdk\SoC\hbirdv2\Board\ddr200t\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\nes_test\application" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

