import os

OUT_BIN='main.bin'
BOOT_BIN='BootLoader.bin'
KERNEL_BIN='tb.bin'
WR_LEN=1    

os.system('copy %s %s' %(BOOT_BIN, OUT_BIN))

out_bin = open(OUT_BIN, 'ab+')




fsize = os.path.getsize('./' + KERNEL_BIN)
kernel_bin = open(KERNEL_BIN, 'rb')

#merge
i=0
while fsize > 0 :
    data = kernel_bin.read(WR_LEN)
    out_bin.write(data)
    i=i+1
    fsize -= WR_LEN
while i<8192:
    out_bin.write(data)
    i=i+1

kernel_bin.close
out_bin.close()

