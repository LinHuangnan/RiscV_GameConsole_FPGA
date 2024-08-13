   .org 0x0
   .global _start
_start:

####################复制程序##############################

    li x5,0x4
    li x1,0x050000
    li x2,0x80000000 # $2: destination address     
    la x3,_os # $3: source address
L1:
    lw x4,0x0(x3)
    sw x4,0x0(x2)
    addi x2,x2,0x4
    addi x3,x3,0x4
    sub x1,x1,x5
    bgt x1,x0,L1

###############################################################
    nop
    nop
    nop
    li x1,0x80000000
    jalr x0,0x0(x1)     #跳到RAM运行程序
_os:

