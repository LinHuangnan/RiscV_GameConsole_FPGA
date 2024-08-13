name = "BootLoader"
filepath = name+".data"
targetpath = name+".txt"
target = open(targetpath, "w")
 
datafile = open(filepath, 'r')
i = 0
ch = datafile.read(8)

target.write("initial begin")
target.write("\n") 

while ch:
    target.write("    inst_mem[%d]=32'h" %i)
    target.write (ch)
    target.write (";")
    target.write("\n") 
    i=i+1
    ch = datafile.read(1)
    ch = datafile.read(8)
target.write ("end")
 
datafile.close()