#!/usr/bin/env python

import yaml
from collections import OrderedDict

def represent_dictionary_order(self, dict_data):
    return self.represent_mapping('tag:yaml.org,2002:map', dict_data.items())

def setup_yaml():
    yaml.add_representer(OrderedDict, represent_dictionary_order)

setup_yaml()  


dic_tt={"name":{"alex":"female","zdk":"male"},"age":[11,22,33,44],"job":[["IT","yunying"],["yunwei","C++"]]}

with open("1.yaml","wb") as f:
    yaml.dump(dic_tt,f,default_flow_style=False)
#default_flow_style=False/True/None
print yaml.dump(dic_tt,default_flow_style=False)

"""
字典转换成yaml格式并且是有序输出的.(必须加上上边两个函数)
pyyaml的常用一些输出参数
stream

指定由于输出YAML流的打开的文件对象。默认值为 None，表示作为函数的返回值返回。

default_flow_style

是否默认以流样式显示序列和映射。默认值为 None，表示对于不包含嵌套集合的YAML流使用流样式。设置为 True 时，序列和映射使用块样式。

default_style

默认值为 None。表示标量不使用引号包裹。设置为 '"' 时，表示所有标量均以双引号包裹。设置为 "'" 时，表示所有标量以单引号包裹。

canonical

是否以规范形式显示YAML文档。默认值为 None，表示以其他关键字参数设置的值进行格式化，而不使用规范形式。设置为 True 时，将以规范形式显示YAML文档中的内容。

indent

表示缩进级别。默认值为 None， 表示使用默认的缩进级别（两个空格），可以设置为其他整数。

width

表示每行的最大宽度。默认值为 None，表示使用默认的宽度80。

allow_unicode

是否允许YAML流中出现unicode字符。默认值为 False，会对unicode字符进行转义。设置为 True 时，YAML文档中将正常显示unicode字符，不会进行转义。

line_break

设置换行符。默认值为 None，表示换行符为 ''，即空。可以设置为 \n、\r 或 \r\n。

encoding

使用指定的编码对YAML流进行编码，输出为字节字符串。默认值为 None，表示不进行编码，输出为一般字符串。

explicit_start

每个YAML文档是否包含显式的指令结束标记。默认值为 None，表示流中只有一个YAML文档时不包含显式的指令结束标记。设置为 True 时，YAML流中的所有YAML文档都包含一个显式的指令结束标记。

explicit_end

每个YAML文档是否包含显式的文档结束标记。默认值为 None，表示流中的YAML文档不包含显式的文档结束标记。设置为 True 时，YAML流中的所有YAML文档都包含一个显式的文档结束标记。

version

用于在YAML文档中指定YAML的版本号，默认值为 None，表示不在YAML中当中指定版本号。可以设置为一个包含两个元素的元组或者列表，但是第一个元素必须为1，否则会引发异常。当前可用的YAML的版本号为1.0、1.1 和1.2。

tags

用于指定YAML文档中要包含的标签。默认值为 None，表示不指定标签指令。可以设置为一个包含标签的字典，字典中的键值对对应各个不同的标签名和值。
————————————————
"""
