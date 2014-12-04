CSAPP的Y86指令集实现
===

# 项目介绍：

能执行Y86指令集的CPU。

基础架构参考《自己动手写CPU》中的OpenMIPS，具体实现参考CSAPP2e。

# 硬件结构：

![Hardware structure of PIPE](https://github.com/Archstacker/Y86/raw/master/PIPE_structure.png)

# 与OpenMIPS相比的改进：

* 小端模式
* 不等长指令的处理
* 指令与数据均存储在内存
* 数据流经过流水线方式的处理

# 待实现的部分：

* 开始rst为1时各部件初始状态确定
* 内存相关数据的命名问题
* comvXX指令集实现

# 存在的问题

* regfile应该是几个写输入端？
* 仿真过程中出现的一些尖峰应该如何处理？
* 仿真过程中出现的一些高阻态应该如何处理？
* 如何统一小端模式实现方式？
* 如何进行异常处理？
