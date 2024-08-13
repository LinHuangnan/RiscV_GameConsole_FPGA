name = "tb"
filepath = name+".bin"
targetpath = name+".data"
target = open(targetpath, "w")
 
binfile = open(filepath, 'rb')
i = 0
ch = binfile.read(1)
 
 
while ch:
  data = ord(ch)
  target.write ("%02X" %(data))
  if i % 8 == 7:
    target.write ("\n")
  i = i + 1
  ch = binfile.read(1)
if i%16==4:
  print("i="+str(4))
  target.write("00000000\n0000000000000000")
elif i%16==8:
  print("i="+str(8))
  target.write("0000000000000000")
elif i%16==12:
  print("i="+str(12))
  target.write("00000000")
 
 
binfile.close()