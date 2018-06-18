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
	zip -qr $@ appinfo bin ${LIBS_PATH} res
	zip -qj $@ $<
	ls -sh $@

pack: ${PACKAGE}

${BIN}: ./src/main.cc | ${CXX} ${INCLUDE} base
	mkdir -p ${BUILD_PATH}; \
		${CXX} -I${INCLUDE} ${CXX_FLAGS} -o $@ $< -L${PROLIN_LIBS} -L${LIBS_PATH} ${LIBS}

TOOLCHAIN_URL = 'https://api.github.com/repos/getzoop/toolchains/releases/assets/7318753'
TOOLCHAIN_FILE = ./third_party/toolchain/cross-armv6l-gcc.tar.gz

${CXX}:
ifneq ($(shell test -e $(TOOLCHAIN_FILE) && echo yes),yes)
	@echo 'Downloading PAX S920 toolchain...';
	@echo -n "Github username: "     ; \
	  read USER_NAME                 ; \
	  echo -n "Github password: "    ; \
	  read -s PASSWORD               ; \
	  echo                           ; \
	  echo -n "Github 2FA token: "   ; \
	  read TOKEN                     ; \
	  curl --progress-bar -fLJ -o ${TOOLCHAIN_FILE} -H "X-GitHub-OTP:$$TOKEN" -H"Accept:application/octet-stream" -u $$USER_NAME:$$PASSWORD ${TOOLCHAIN_URL}
endif

	@echo "Extracting ARMv6l toolchain..."
	mkdir -p ${ARMV6_ROOT}
	pv ./third_party/toolchain/cross-armv6l-gcc.tar.gz | tar xzp -C /
	@echo "ARMv6l toolchain ready."
	$(MAKE) base

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
	@echo "The base libraries make a huge AIP to install."
	@echo "You should consider run 'make dry' if the target device already has received this base libraries."

clean:
	-rm -rf ${LIBS_PATH}
	-rm -rf ${PACKAGE_PATH}
	-rm -rf ${BUILD_PATH}

