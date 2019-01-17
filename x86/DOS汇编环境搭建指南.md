# 这个文件夹下是什么？ #

在DOS环境下编写的汇编程序源码。<br>
旨在用汇编的代码解释计算机的可用资源特性。

## 怎么使用运行？ ##

1. 你的电脑至少要运行Windows95以上。
2. 安装DosBox0.74。
3. 下载MASM，微软的汇编套件，包含了编译和debug的工具。

## DosBox使用方法 ##

1. 打开DosBox后会打开两个窗口，不要关闭DOSbox state Window，在DOSbox 0.74窗口下输入
2. mount [虚拟盘符名] [MASM的path]

	> 例如mount E E:\masm，E是一个暂时的磁盘名，PATH填写MASM的目录

3. 输入  E: 即可进入MASM环境<br>
注：DOSbox的有点在于可以直接在Win10下的文件管理系统下操作，<br>
也就是把源代码直接放到MASM文件夹下便完成了环境配置。
4. 使用 ML DEBUG 命令对源码和可执行文件调试吧。

