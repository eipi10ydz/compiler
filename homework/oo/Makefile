SRC = t.cpp test.cpp s.c
TARGET = t s anonymous_namespace
all : $(TARGET)
$(TARGET) : $(SRC)
	clang++ -std=c++0x -g t.cpp -o t
	clang++ -std=c++0x -g anonymous_namespace.cpp -o anonymous_namespace
	clang -static -g s.c -o s
	#clang++ -std=c++0x -g s.cpp -o s
	objdump -dSC t > output_t
	objdump -dSC s > output_s
	objdump -dSC anonymous_namespace > output_anonymous_namespace

.PHONY : clean all

clean : 
	rm output_* t s anonymous_namespace
