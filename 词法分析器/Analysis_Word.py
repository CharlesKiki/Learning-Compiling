#!/usr/bin/env python3.4
# coding=utf-8
""" 
    目标处理语言并不进行分行
    这份代码是词法分析器，采用了人肉构造状态机的方式来辨别源代码文件中的Token
    初步进行代码分析之后生成Tmp文件，内容为格式标准的一行的代码
 """
import sys
import string

keywards = {}

# 关键字部分
# 每一个关键字对应一个符号
keywards['False'] = 101
keywards['class'] = 102
keywards['finally'] = 103
keywards['is'] = 104
keywards['return'] = 105
keywards['None'] = 106
keywards['continue'] = 107
keywards['for'] = 108
keywards['lambda'] = 109
keywards['try'] = 110
keywards['True'] = 111
keywards['def'] = 112
keywards['from'] = 113
keywards['nonlocal'] = 114
keywards['while'] = 115
keywards['and'] = 116
keywards['del'] = 117
keywards['global'] = 118
keywards['not'] = 119
keywards['with'] = 120
keywards['as'] = 121
keywards['elif'] = 122
keywards['if'] = 123
keywards['or'] = 124
keywards['yield'] = 125
keywards['assert'] = 126
keywards['else'] = 127
keywards['import'] = 128
keywards['pass'] = 129
keywards['break'] = 130
keywards['except'] = 131
keywards['in'] = 132
keywards['raise'] = 133

# 符号
keywards['+'] = 201
keywards['-'] = 202
keywards['*'] = 203
keywards['/'] = 204
keywards['='] = 205
keywards[':'] = 206
keywards['<'] = 207
keywards['>'] = 208
keywards['%'] = 209
keywards['&'] = 210
keywards['!'] = 211
keywards['('] = 212
keywards[')'] = 213
keywards['['] = 214
keywards[']'] = 215
keywards['{'] = 216
keywards['}'] = 217
keywards['#'] = 218
keywards['|'] = 219
keywards[','] = 220
# 变量
# keywards['var'] = 301

# 常量
# keywards['const'] = 401

# Error
# keywards['const'] = 501

# Signlist符号表，作为词法分析输出结果
signlist = {}


# 预处理函数，将文件中的空格，换行等无关字符处理掉
# 该方法接受一个源代码文件，输出一个单个的词进入缓存文件
# 变量sign
def pretreatment(file_name):
    try:
        # 读取源代码文件
        fp_read = open(file_name, 'r')
        # 生成临时文件，符号表
        fp_write = open('file.tmp', 'w')
        # 标记sign实际上是状态机中的节点标识符
        sign = 0
        while True:
            # 按照行处理原始代码
            read = fp_read.readline()
            # 无法读取报错
            if not read:
                break
            # 检查当前行的长度，该长度包含空格
            length = len(read)
            i = -1
            # If length - i == -1 当前行为空行 则开始处理下一行
            while i < length - 1:
                i += 1
                # 此处的一次sign标记和内部if判断实际上是一种状态图的实现
                # 但是从形式上来看类似字符串的匹配
                if sign == 0:
                    if read[i] == ' ':
                        continue
                if read[i] == '#':
                    break
                # 检查是否是空格
                elif read[i] == ' ':
                    if sign == 1:
                        continue
                    else:
                        sign = 1
                        fp_write.write(' ')
                # 检查是否是回车
                # 运行的结果是在Tmp文件中没有回车和换行，只有一行的长代码
                elif read[i] == '\t':
                    if sign == 1:
                        continue
                    else:
                        sign = 1
                        # 以空格代替回车换行
                        fp_write.write(' ')
                elif read[i] == '\n':
                    if sign == 1:
                        continue
                    else:
                        fp_write.write(' ')
                        sign = 1
                elif read[i] == '"':
                    fp_write.write(read[i])
                    i += 1
                    while i < length and read[i] != '"':
                        fp_write.write(read[i])
                        i += 1
                    if i >= length:
                        break
                    fp_write.write(read[i])
                elif read[i] == "'":
                    fp_write.write(read[i])
                    i += 1
                    while i < length and read[i] != "'":
                        fp_write.write(read[i])
                        i += 1
                    if i >= length:
                        break
                    fp_write.write(read[i])
                else:
                    sign = 3
                    fp_write.write(read[i])
    except Exception:
        print(file_name, ': This FileName Not Found!')

# 该方法
def save(string):
    # 检查是否是关键词
    if string in keywards.keys():
        # 已经是关键字
        if string not in signlist.keys():
            # 添加关键字的对应符号
            signlist[string] = keywards[string]
    # 非符号表关键字
    else:
        try:
            # 数字，强制类型转换，代码的格式是String类型
            float(string)
            # 进行常量检查
            save_const(string)
        except ValueError:
            save_var(string)


def save_var(string):
    # 检查是否在符号表中
    if string not in signlist.keys():
        # 检查字符串去除首尾空格换行后的长度
        if len(string.strip()) < 1:
            pass
        else:
            if is_signal(string) == 1:
                # 如果是变量则添加进符号表
                signlist[string] = 301
            else:
                # 报错处理
                signlist[string] = 501


def save_const(string):
    if string not in signlist.keys():
        signlist[string] = 401


def save_error(string):
    if string not in signlist.keys():
        signlist[string] = 501


def is_signal(s):
    if s[0] == '_' or s[0] in string.ascii_letters:
        for i in s:
            if i in string.ascii_letters or i == '_' or i in string.digits:
                pass
            else:
                return 0
        return 1
    else:
        return 0

# 该方法处理已经初步完成的Tmp代码
def recognition(filename):
    try:
        fp_read = open(filename, 'r')
        string = ""
        sign = 0
        while True:
            read = fp_read.read(1)
            if not read:
                break
            if read == ' ':
                if len(string.strip()) < 1:
                    sign = 0
                    pass
                else:
                    if sign == 1 or sign == 2:
                        string += read
                    else:
                        save(string)
                        string = ""
                        sign = 0
            # 如果读取的内容是非终结符 
            elif read == '(':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save('(')
            elif read == ')':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save(')')
            elif read == '[':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save('[')
            elif read == ']':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save(']')
            elif read == '{':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save('{')
            elif read == '}':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save('}')
            elif read == '<':
                save(string)
                string = ""
                save('<')
            elif read == '>':
                save(string)
                string = ""
                save('>')
            elif read == ',':
                save(string)
                string = ""
                save(',')
            elif read == "'":
                string += read
                if sign == 1:
                    sign = 0
                    save_const(string)
                    string = ""
                else:
                    if sign != 2:
                        sign = 1
            elif read == '"':
                string += read
                if sign == 2:
                    sign = 0
                    save_const(string)
                    string = ""
                else:
                    if sign != 1:
                        sign = 2
            elif read == ':':
                if sign == 1 or sign == 2:
                    string += read
                else:
                    save(string)
                    string = ""
                    save(':')
            elif read == '+':
                save(string)
                string = ""
                save('+')
            elif read == '=':
                save(string)
                string = ""
                save('=')
            else:
                string += read
    except Exception as e:
        print(e)


def main():
    # 检查参数长度
    if len(sys.argv) < 2:
        print("Please Input FileName")
    else:
        # 进入文本预处理状态
        pretreatment(sys.argv[1])
    # 进行词法分析
    recognition('file.tmp')
    # 打印符号表
    for i in signlist.keys():
        print("(", signlist[i], ",", i, ")")


if __name__ == '__main__':
    main()
