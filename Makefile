##################################################
# JIST (Java In Simulation Time) Project
# Timestamp: <Makefile Tue 2004/04/06 17:38:53 barr pompom.cs.cornell.edu>
#

# Copyright (C) 2004 by Cornell University
# All rights reserved.
# Refer to LICENSE for terms and conditions of use.

include Makefile.include
SUBDIRS := src src/memprof

JAR=jar
JAR_FLAGS=cf

JIST_JAR_FILE=jist.jar
SWANS_JAR_FILE=swans.jar
SRC_TAR_FILE=jist-swans-$(VERSION)-src.tar.gz
TAR_FILE=jist-swans-$(VERSION).tar.gz

.PHONY: $(SUBDIRS)

src:
	make -C src

cleansrc:
	make -C src clean

memprof:
	make -C src/memprof

bench:
	make -C bench

clean: cleanlocal

cleanlocal:
	-rm -rf build/*
	-rm -f $(JIST_JAR_FILE)
	-rm -f $(SWANS_JAR_FILE)
	-rm -f $(SRC_TAR_FILE)
	-rm -f $(TAR_FILE)

jistjar: $(JIST_JAR_FILE)

jist.jar: src
	rm -f jist.jar
	cd src; find jist/runtime -name \*.class -print0 | xargs -0 $(JAR) cmf ../jist.manifest ../jist.jar 
	cd src; find jist/minisim -name \*.class -print0 | xargs -0 $(JAR) uf ../jist.jar
	#jar uf jist.jar -C libs bcel.jar -C libs jargs.jar -C libs log4j.jar -C libs bsh.jar -C libs jython.jar
	$(JAR) uf jist.jar LICENSE

swansjar: $(SWANS_JAR_FILE)

swans.jar: src
	rm -f swans.jar
	cd src; find jist/swans -name \*.class -print0 | xargs -0 $(JAR) cmf ../swans.manifest ../swans.jar 
	cd src; find driver -name \*.class -print0 | xargs -0 $(JAR) uf ../swans.jar
	$(JAR) uf swans.jar LICENSE

tarballsrc:
	rm -f $(SRC_TAR_FILE)
	cvs -d $(CVS_ROOT) export -d jist-swans-$(VERSION) -D now code
	chmod a+r -R jist-swans-$(VERSION)
	chmod a+x `find jist-swans-$(VERSION) -type d`
	tar --totals -czf $(SRC_TAR_FILE) jist-swans-$(VERSION)
	rm -rf jist-swans-$(VERSION)

tarball:
	rm -f $(TAR_FILE)
	cvs -d $(CVS_ROOT) export -d jist-swans-$(VERSION) -D now code
	cd jist-swans-$(VERSION); make
	chmod a+r -R jist-swans-$(VERSION)
	chmod a+x `find jist-swans-$(VERSION) -type d`
	tar --totals -czf $(TAR_FILE) jist-swans-$(VERSION)
	rm -rf jist-swans-$(VERSION)

check-env:
ifndef JAVA_HOME
    $(error You need to set JAVA_HOME before compiling)
endif

test: src
	./bin/swans driver.aodvsim -n 25 -f 2000x2000 -a grid:5x5 -t 10,600,60
	./bin/swans driver.bordercast -p zrp:2 --iarp=iarp:inf -e 300 -n 10 -f 200x200 -a grid:5x5 -b 5,100,20
	./bin/swans driver.dsrtest
	./bin/swans driver.heartbeat 5 100 5
	./bin/swans driver.ip
	./bin/swans driver.memory 20
	./bin/swans driver.ndp -m time -n 50 -d 4082 -t 900
	./bin/swans driver.spatial -d 100 -n 20
	./bin/swans driver.tcp
	./bin/swans driver.threaded
	./bin/swans driver.udp
