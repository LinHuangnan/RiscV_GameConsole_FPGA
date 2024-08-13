# 基于RISC-V的多功能游戏机

## 作品全貌图
![1](./picture/作品全貌图.jpg)

## 项目概述

本项目基于紫光同创FPGA平台，采用RISC-V架构设计并实现了一款多功能游戏机，能够运行NES模拟器，支持多种外设，并能够接收和解析控制信号。其设计目的是创建一个灵活可扩展的游戏平台。

## 代码结构

├── **e203**                  # FPGA 代码
├── **HBirdv2_Prj**          # 软件代码
├── **bin_generate**          # 将软件代码转为可以用 Pango 开发软件烧录器直接烧录的 SFC 文件，注意选择烧录地址
├── **以太网上位机**           # 自制的以太网上位机
└── **快速验证比特流**         # 将其内的文件依次烧录进 FLASH 即可验证整个工程

## 设计目标

- **平台**：基于紫光同创FPGA
- **架构**：RISC-V处理器
- **功能**：运行NES模拟器，支持多款游戏和外设

## 主要技术特点

- 移植RISC-V到FPGA，并设计多款趣味游戏。
- 采用DDR3和FLASH，提供充足的内存空间。
- FPGA直接驱动多个外设，CPU负责调度。
- 游戏切换灵活，音频存储在SD卡中。

## 关键性能指标

- **CPU主频**：50MHz
- **Dhrystone跑分**：1.28DMIPS/MHz
- **视频输出**：支持HDMI输出640x480@(60Hz)视频，音频采样率为48kHz
- **接口支持**：支持PS2手柄和红外遥控
- **传输**：千兆以太网支持视频传输

## 系统组成及功能说明

### 系统框架

![2](./picture/system_top.png)

系统的核心是蜂鸟e203 RISC-V内核，负责全局控制。系统通过多个模块实现功能：

- **PS2手柄和红外遥控解析模块**：解析控制信号并传递给内核。
- **iCB总线至AXI总线转换模块**：转换数据总线以支持DDR3接口。
- **DDR3 AXI0接口读写控制模块**：管理图形数据的存取。
- **以太网模块**：支持UDP协议的数据传输。
- **LCD和HDMI模块**：负责图像输出。
- **SD卡模块**：用于音频数据读取。

![3](./picture/ps2.png)

![4](./picture/ethenet.png)

![5](./picture/LCD.png)

![6](./picture/hdmi.png)


### 模块介绍

- **蜂鸟e203 RISC-V内核**：精简后运行在50MHz主频。
- **PS2手柄和红外遥控模块**：解析手柄和遥控器信号。
- **以太网模块**：修改自正点原子开发板例程，实现UDP协议发送。
- **LCD和HDMI模块**：基于开源模块修改，支持视频和音频输出。

## 完成情况及性能参数

### 基础功能

- 成功移植RISC-V内核，支持NES模拟器和两款基础游戏。
- 支持游戏的切换和图像刷新，保证基本的用户体验。

### 扩展功能

- **游戏切换**：通过FLASH不同地址区间实现游戏切换。
- **图像刷新率**：60Hz的图像刷新，支持多种显示输出。
- **外设支持**：兼容标准游戏手柄，支持红外遥控。
- **传感器驱动**：支持氛围灯，实时显示PS2按键值。
- **以太网广播**：使用UDP协议进行游戏转播。

![7](./picture/menu.png)

![8](./picture/game.png)

### 可拓展之处

- 进一步优化NES模拟器的性能。
- 利用剩余FPGA资源进行图像处理，如插值处理。


## 参考文献

1. Philips Consumer Electronics International B.V. et al., "High-definition multimedia interface," 2006.

# RISC-V Multifunctional Game Console

This project focuses on developing a multifunctional game console leveraging the RISC-V architecture. Built on the Unisoc FPGA platform, the console supports a variety of entertaining games, integrating an NES emulator and multiple peripherals for enhanced functionality and interactivity.

## Table of Contents

- [基于RISC-V的多功能游戏机](#基于risc-v的多功能游戏机)
  - [作品全貌图](#作品全貌图)
  - [项目概述](#项目概述)
  - [代码结构](#代码结构)
  - [设计目标](#设计目标)
  - [主要技术特点](#主要技术特点)
  - [关键性能指标](#关键性能指标)
  - [系统组成及功能说明](#系统组成及功能说明)
    - [系统框架](#系统框架)
    - [模块介绍](#模块介绍)
  - [完成情况及性能参数](#完成情况及性能参数)
    - [基础功能](#基础功能)
    - [扩展功能](#扩展功能)
    - [可拓展之处](#可拓展之处)
  - [参考文献](#参考文献)
- [RISC-V Multifunctional Game Console](#risc-v-multifunctional-game-console)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Application Areas](#application-areas)
  - [Key Technical Features](#key-technical-features)
  - [Key Performance Indicators](#key-performance-indicators)
  - [Innovations](#innovations)
  - [System Components and Functionality](#system-components-and-functionality)
    - [Hummingbird e203 RISC-V Core](#hummingbird-e203-risc-v-core)
    - [PS2 and Infrared Modules](#ps2-and-infrared-modules)
    - [Bus Conversion Module](#bus-conversion-module)
    - [DDR3 Read/Write Control Module](#ddr3-readwrite-control-module)
    - [Ethernet Module](#ethernet-module)
    - [LCD and HDMI Modules](#lcd-and-hdmi-modules)
    - [SD Card Module](#sd-card-module)
  - [Achievements and Performance](#achievements-and-performance)
  - [Future Extensions](#future-extensions)
  - [Acknowledgments](#acknowledgments)
  - [Appendix](#appendix)

## Project Overview

The goal of this project is to design and implement a multifunctional game console capable of running multiple games. It utilizes the RISC-V architecture on the Unisoc FPGA platform to achieve efficient performance and versatility, capable of executing NES emulators and supporting various output peripherals.

## Application Areas

- **Embedded Microprocessors**: The project demonstrates the use of RISC-V in embedded systems.
- **Entertainment Systems**: Development of a gaming console showcases its application in the entertainment industry.
- **FPGA Development**: Utilization of the Unisoc FPGA platform highlights advanced hardware-software integration.

## Key Technical Features

- **Platform**: Based on the Unisoc FPGA platform with a RISC-V architecture.
- **Memory**: Integration of DDR3 and FLASH provides substantial memory space for multiple games.
- **Peripheral Management**: Direct FPGA control of peripherals allows efficient CPU task management.
- **Game Storage and Switching**: Games are individually stored in FLASH and loaded into high-speed RAM as needed, allowing dynamic game switching.
- **Audio Management**: Audio files stored on SD cards facilitate a large library of music for games.
- **NES Emulator**: Capability to run NES games, enhancing the console's gaming potential.

## Key Performance Indicators

- **CPU Frequency**: 50 MHz, achieving a Dhrystone score of 1.28 DMIPS/MHz.
- **HDMI Output**: Supports 640x480 resolution at 60Hz, with an audio sampling rate of 48000 Hz.
- **RGB-LCD Output**: Supports video output at 640x480 resolution and 60Hz refresh rate.
- **Ethernet Support**: Gigabit Ethernet capability for video transmission.
- **Peripheral Support**: Compatible with PS2 controllers and infrared remote controls.
- **Game and Music Switching**: Supports dynamic game switching and music playback.

## Innovations

- **Core Optimization**: Streamlined the Hummingbird e203 RISC-V core, increasing CPU frequency from 16 MHz to 50 MHz.
- **Direct Frame Access**: Graphics frames stored in DDR3 are accessed directly by the FPGA HDMI control module, achieving a 60Hz refresh rate.
- **Hardware-Driven Peripherals**: FPGA-driven hardware control for PS2 controllers and infrared modules replaces traditional CPU soft drivers.
- **Comprehensive HDMI Implementation**: HDMI driver implementation includes PHY layer, supporting audio and video transmission per HDMI standards.

## System Components and Functionality

### Hummingbird e203 RISC-V Core

The core has been simplified to run at a 50 MHz frequency, supporting essential functionalities and optimizing the FPGA's logical resources. The core handles global control and scheduling tasks.

### PS2 and Infrared Modules

These modules decode signals from PS2 controllers and infrared remotes, transmitting key values directly to the e203 core's GPIO inputs, allowing software to easily detect button inputs.

### Bus Conversion Module

The module converts the 32-bit ICB bus used by the e203 core to a 64-bit AXI bus, enabling access to the DDR3 memory module.

### DDR3 Read/Write Control Module

This module continuously reads video data from the DDR3 memory into the frame buffer, maintaining a 60Hz refresh rate.

### Ethernet Module

Modified from the PGL22G development board examples, the Ethernet module transmits video data over UDP protocol, interfacing with the Gigabit Ethernet PHY chip via the GMII-to-RGMII conversion.

### LCD and HDMI Modules

- **LCD Module**: Drives a 640x480 display area on a 1024x600 screen using custom timing parameters to optimize buffer size.
- **HDMI Module**: Utilizes a PLL to generate necessary clock signals for pixel and audio data transmission, supporting 10-bit parallel to serial data conversion.

### SD Card Module

Facilitates audio data reading from SD cards using SPI protocol, controlled by the CPU to specify read start and end addresses.

## Achievements and Performance

- Successfully ported the Hummingbird e203 RISC-V core onto the Unisoc FPGA, achieving 50 MHz frequency.
- Developed and tested basic games and an NES emulator on the system, maintaining a consistent 60 FPS for native games.
- Supported game switching, increased image refresh rates, standard controller compatibility, and peripheral integration.

## Future Extensions

- **NES Emulator Optimization**: Utilize assembly coding to enhance the emulator's performance and gameplay fluidity.
- **Advanced Image Processing**: Implement image interpolation techniques to adapt output resolution to various displays, utilizing remaining FPGA resources.

## Acknowledgments

This project has broadened our understanding of FPGA usage and design, highlighting the importance of hardware-software collaboration. It showcases the benefits of FPGA-based peripheral control over traditional CPU methods.

## Appendix

- **HDMI Protocol Data Structure and ECC**: Detailed structures and error correction code are included for reference.

For additional details, refer to the full [design report](./设计报告.pdf).