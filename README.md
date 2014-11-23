CSAPP的Y86指令集实现
===

# 项目介绍：

能执行Y86指令集的CPU。

基础架构参考《自己动手写CPU》中的OpenMIPS，具体实现参考CSAPP2e。

# 硬件结构：

![Hardware structure of PIPE](https://github.com/Archstacker/Y86/raw/master/PIPE_structure.png)

# 与OpenMIPS相比的改进：

* 不等长指令的处理
* 指令与数据均存储在内存
* 数据流经过流水线方式的处理

# 待实现的部分：

* 开始rst为1时各部件初始状态确定
* 异常相关处理的实现（halt命令）
* 内存相关数据的命名问题
* 按照CSAPP的变量命名统一规范
* 清理多余的宏定义
* comvXX指令集实现
* 一些高电平的处理
* 尖峰处理

