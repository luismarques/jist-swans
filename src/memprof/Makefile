CC = gcc
CC_OPT = -g -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux -I${JAVA_HOME}/include/darwin
CLASSPATH=../../libs/jargs.jar:../../build

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
LD_OPT = -shared
endif

ifeq ($(UNAME), Darwin)
LD_OPT = -bundle
endif

all: #libmemprof.so memprof.class

clean:
	rm -f *.so
	rm -f *.o
	rm -f *.class
	rm -f memprof.h

libmemprof.so: memprof.o
	ld -o $@ $(LD_OPT) $< 

memprof.o: memprof.c
	$(CC) $(CC_OPT) -o $@ -c $<

memprof.c: memprof.h
	touch memprof.c

memprof.h: memprof.class
	javah -classpath ../../build -o $@ memprof.memprof

%.class: %.java
	javac -classpath $(CLASSPATH):$$CLASSPATH $<
