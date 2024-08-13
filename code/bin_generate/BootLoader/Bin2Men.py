name = "BootLoader"
filepath = name+".bin"
targetpath = name+".data"
target = open(targetpath, "w")
 
binfile = open(filepath, 'rb')
i = 0
ch = binfile.read(1)
 
 
while ch:
  data = ord(ch)
  target.write ("%02X" %(data))
  if i % 4 == 3:
    target.write ("\n")
  i = i + 1
  ch = binfile.read(1)
 
 
 
binfile.close()