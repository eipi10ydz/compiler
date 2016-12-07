SRC = fib.c fib-m.ll
TARGET = fib-m fib

all : $(TARGET)
$(TARGET) : $(SRC)
	clang -O3 fib.c -o fib
	clang -O3 fib-m.ll -o fib-m

.PHONY : all clean

clean :
	rm fib-m fib
