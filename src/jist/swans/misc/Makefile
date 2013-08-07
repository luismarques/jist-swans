CC = gcc
CC_OPT = -g -O3 -ffast-math -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux -I${JAVA_HOME}/include/darwin
CP=../../../../build:$(CLASSPATH)

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
LD_OPT = -shared
endif

ifeq ($(UNAME), Darwin)
LD_OPT = -bundle
endif


all: libswansutil.so Util.class

clean:
	@rm -f *.so
	@rm -f *.o
	@rm -f native.h

libswansutil.so: native.o
	@-ld -lm -o $@ $(LD_OPT) $<

native.o: native.c
	@-$(CC) $(CC_OPT) -o $@ -c $<

native.c: native.h
	touch native.c

native.h: ../../../../build/jist/swans/misc/Util.class
	javah -classpath $(CP) -o $@ jist.swans.misc.Util
	touch native.h

%.class: %.java
	javac -d ../../../../build/ -classpath $(CP) $<

