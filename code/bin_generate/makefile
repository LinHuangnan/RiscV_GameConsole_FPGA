
run:
	copy C:\NucleiStudio_workspace\HBirdv2_Prj\gameMenu\Debug\gameMenu.elf tb.elf
	riscv-nuclei-elf-objdump -D tb.elf > tb.asm
	riscv-nuclei-elf-objcopy -O binary tb.elf tb.bin
	python Bin2Men.py
	python data2rom.py
	python BinMerge.py
	copy main.bin C:\pango\prj\e203_test\generate_bitstream\gameMenu.sfc
.PHONY : clean
clean:
	del  *.asm tb.bin main.bin *.txt *.data *.elf