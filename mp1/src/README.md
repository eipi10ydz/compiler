# MP1.2

## 基本

### 运算符

- 逻辑运算符

	- 一元 : not

	- 二元 : <=, <, =

- 算术运算符

	- 一元 : ~

	- 二元 : +, -, *, /

### 关键字(大小写不分，除true与false首字母必须小写，返回时对应cool-parse.h里面的宏)

- class

- else

- false(需要修改cool\_yylval.boolean)

- fi

- if

- in

- inferits

- isvoid

- let

- loop

- pool

- then

- while

- case

- esac

- new

- of

- not

- true(需要修改cool\_yylval.boolean)

### 标识符(除关键字)

- type id : 大写字母开头，由数字、字母、下划线组成的串(需要修改cool\_yylval.symbol，并把匹配的内容加入idtable)

- object id : 小写字母开头，由数字、字母、下划线组成的串(需要修改cool\_yylval.symbol，并把匹配的内容加入idtable)

### 其它

- 整数常量 : 0-9数字组成的非空串(需要修改cool\_yylval.symbol，并把匹配的内容加入inttable)

- 空白符 : 空格, \n, \f, \r, \t, \v

- => : case语句中用到

- <- : 赋值运算符

- ',', ':', ';' : 逗号，分号，冒号

- '('， ')'， '{'， '}' : 括号

- '.' : 用于dispatch

- '@' : 用于dispatch中显式调用父类被隐藏的方法

## 加强

### 注释

- 单行注释

	- 遇到"--"则进入单行注释的start condition，遇到'\n'退出

- 多行注释

	- 遇到"(*"则进入多行注释的start condition

	- 由于多行注释可以嵌套，因此使用变量layers统计层数，每遇一个"(*"则layers加1，否则layers减1，当layers为0退出

	- 跳过所有非'*', '\n', '('字符

		- 如果'('后面不是'*'，跳过

		- 如果'*'后面不是')'，跳过

### 字符串

- 遇到'"'进入字符串的start condition

- 遇到'\n'说明为多行字符串且未使用'\'转义，报错"Unterminated string constant"，并认为字符串结束

- 根据要求，遇到'\0'需要在这个字符串的结束处开始继续分析

	- 因此为预防下一个引号前的可能出现的问题(这些问题会导致字符串提前结束)，使用bool变量ifvalid标记是否出现'\0'

		- EOF

		- 非转义换行(字符串的start coondition立即结束)

	- 根据分析reference-binaries里面的结果可知，null character的优先级高于string constant too long(即如果出现'\0'且字符串长度超过1024，会报错null character)，因此在结束后需要先判断ifvalid是否为真，再判断字符串是否超出规定长度

- 除4个字符'\b', '\t', '\n', '\f'外其余字符'c'前加'\'变为"\c"将转变为'c'，于是分别处理

	- '\'后加'\b', '\t', '\n', '\f'会变回'\b', '\t', '\n', '\f', 其他字符'c'前加'\'变回'c'(除'\0')

- '\' : 单独识别'\'防止出现'\'后文件结束的情形(如下文中所提到的测试的第一条)。同时由于上面未处理'\'后跟'\0'的情形，此处可以先识别'\'，把'\0'交给上面处理'\0'的部分处理

- EOF : 报错"EOF in string constant"

- 对于非'\', '\n', '\0', '"'的字符直接跳过

## 其它

- 由于在字符串外出现的一些其他字符(如'>', '[', ']'等)非法，因此在第二部分最后加入'.'以识别此类字符

- 由于将字符串匹配部分加入string\_buf十分常见，因此实现check\_length函数，用来把yytext中需要部分加入string\_buf，并返回bool来确认字符串长度是否超出最大值，如果超出返回false

- cool\_yylval是一个类型为yystype(YYSTYPE)的联合体，有对应的匹配需要改变它的值，以便main函数中使用

## 测试(注:第一个已变为补充作业)

- 补充作业

	- 如果输入文件以"\&lt;&lt;EOF&gt;&gt;结尾，reference-binaries中的lexer会出现奇怪的现象，即输出了"\

	- 在处理字符串的时候加入对单个'\'的处理后，可解决该问题(下面的./lexer是我的程序，且结尾必须是'\'且不带其它字符，即可复现下面的现象)

	- 这样处理的好处不止在于处理这种情况，对于'\'后接'\0'的问题也能很好地解决

	- 至于为什么给的lexer会出现这样的问题，暂时没有想明白

<pre>
$ cat t.cl
"\
$ ../reference-binaries/lexer t.cl
#name "t.cl"
"\#1 ERROR "EOF in string constant"
$ ./lexer t.cl
#1 ERROR "EOF in string constant"
</pre>

处理代码

<pre>
"\\" { check_length("\\"); }
</pre>

- 遇到无效字符返回包含这个字符的字符串, 并从下个字符开始继续分析

- 如果字符串出现了'\0'但长度长于1024，报错null character

- 如果字符串长度超出1024但没出现'\0'，报错string constant too long

- 可以识别'\'后面加'\0'的字符串

- 多行字符串

- 非转义换行则字符串结束

- 嵌套注释

- 关键字大小写不分(除true, false首字母小写)

- 行数
	- 字符串中'\' + '\n'

	- 字符串中只有'\n'(报错)

	- 单行注释

	- 多行注释中换行

	- 其他地方的换行

- 各种转义字符

- 处理注释不匹配的"\*)"与"(\*"

