################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../application/lcd.c \
../application/main.c \
../application/palette.c \
../application/system.c 

OBJS += \
./application/lcd.o \
./application/main.o \
./application/palette.o \
./application/system.o 

C_DEPS += \
./application/lcd.d \
./application/main.d \
./application/palette.d \
./application/system.d 


# Each subdirectory must supply rules for building sources it contributes
application/%.o: ../application/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-nuclei-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -mno-save-restore -O2 -ffunction-sections -fdata-sections -fno-common --specs=nano.specs --specs=nosys.specs  -g -D__IDE_RV_CORE=e203 -DSOC_HBIRD -DDOWNLOAD_MODE=DOWNLOAD_MODE_ILM -DDOWNLOAD_MODE_STRING=\"ILM\" -DBOARD_DDR200T -I"C:\NucleiStudio_workspace\HBirdv2_Prj\game2048\hbird_sdk\NMSIS\Core\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\game2048\hbird_sdk\SoC\hbirdv2\Common\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\game2048\hbird_sdk\SoC\hbirdv2\Board\ddr200t\Include" -I"C:\NucleiStudio_workspace\HBirdv2_Prj\game2048\application" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


