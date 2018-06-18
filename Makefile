ARMV6_ROOT ?= /opt/cross
PROLIN_SDK ?= ./third_party/prolin_sdk/
PROJECT = Sample
LIBS_PATH = ./lib
BUILD_PATH = ./default
PACKAGE_PATH = ./pkg

CXX := ${ARMV6_ROOT}/bin/arm-armv6l-linux-gnueabi-g++
CXX_FLAGS := -O0 -Wall -funwind-tables -march=armv6 -fpermissive -std=c++17
INCLUDE := ${PROLIN_SDK}/include
PROLIN_LIBS := ${PROLIN_SDK}/lib
BIN = ${BUILD_PATH}/${PROJECT}
PACKAGE = ${PACKAGE_PATH}/${PROJECT}.aip
LIBS := -lcrypto -lfreetype -lpng -lcbinder -lz -losal

.PHONY: clean pack base ${PACKAGE}

all: ${PACKAGE}

${PACKAGE}: ${BIN} 
	mkdir -p ${PACKAGE_PATH}
	-rm -f $@
	zip -qr $@ appinfo ${LIBS_PATH}
	zip -qj $@ $<
	ls -sh $@

pack: ${PACKAGE}

${BIN}: ./src/main.cc | ${CXX} ${INCLUDE} base
	mkdir -p ${BUILD_PATH}; \
		${CXX} -I${INCLUDE} ${CXX_FLAGS} -o $@ $< -L${PROLIN_LIBS} -L${LIBS_PATH} ${LIBS}

TOOLCHAIN_URL = 'https://drive.google.com/file/d/1b3v_N5LDSYqAv5oHd5p2jTSR6djOedC4/view?usp=sharing'
TOOLCHAIN_FILE = ./third_party/toolchain/cross-armv6l-gcc.tar.gz

${CXX}:
ifneq ($(shell test -e $(TOOLCHAIN_FILE) && echo yes),yes)
	@echo 'Downloading PAX S920 toolchain...';
	wget https://raw.githubusercontent.com/circulosmeos/gdown.pl/master/gdown.pl
	perl gdown.pl "${TOOLCHAIN_URL} ${TOOLCHAIN_FILE}
endif
	@echo "Extracting ARMv6l toolchain..."
	mkdir -p ${ARMV6_ROOT}
	pv ./third_party/toolchain/cross-armv6l-gcc.tar.gz | tar xzp -C /
	@echo "ARMv6l toolchain ready."

base:
	@echo "Linking the base libraries..."
	mkdir -p ${LIBS_PATH}
	cd ${LIBS_PATH}; \
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/ld-linux.so.3 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/libc.so.6 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/libdl.so.2 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/libm.so.6 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/libpthread.so.0 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/librt.so.1 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/libgcc_s.so.1 . ;\
	  ln -sf ${ARMV6_ROOT}/arm-armv6l-linux-gnueabi/lib/libstdc++.so.6 .;

clean:
	-rm -rf ${LIBS_PATH}
	-rm -rf ${PACKAGE_PATH}
	-rm -rf ${BUILD_PATH}

