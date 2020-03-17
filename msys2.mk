PATH_INSTALL = /usr/local/bin
PATH_JIT = $(PATH_INSTALL)/lua/jit
FILES_MODULE = cjson.dll int64.dll uint64.dll

help:
	@echo targets: build clean install uninstall

build: clean
	# 编译luajit解释器
	$(MAKE) -C luajit-2.1

	# 编译lua模块cjson
	gcc -Os -Wall -fPIC -shared \
		luajit-2.1/src/lua51.dll \
		cjson/strbuf.c \
		cjson/lua_cjson.c \
		cjson/fpconv.c \
		-o cjson.dll \
		-Iluajit-2.1/src \
		-Icjson

	# 编译lua模块int64
	gcc -Os -Wall -fPIC -shared \
		luajit-2.1/src/lua51.dll \
		int64.c \
		-o int64.dll \
		-Iluajit-2.1/src

	# 编译lua模块uint64
	gcc -Os -Wall -fPIC -shared \
		luajit-2.1/src/lua51.dll \
		int64.c \
		uint64.c \
		-o uint64.dll \
		-Iluajit-2.1/src

clean:
	$(MAKE) -C luajit-2.1 clean
	rm -f $(FILES_MODULE)

install: uninstall
	mkdir -p $(PATH_JIT)
	cd luajit-2.1/src && install -m 0644 lua51.dll luajit.exe $(PATH_INSTALL)
	cd luajit-2.1/src/jit && install -m 0644 bc.lua bcsave.lua dump.lua p.lua v.lua zone.lua dis_x86.lua \
		dis_x64.lua dis_arm.lua dis_arm64.lua dis_arm64be.lua dis_ppc.lua dis_mips.lua \
		dis_mipsel.lua dis_mips64.lua dis_mips64el.lua vmdef.lua $(PATH_JIT)
	install -m 0644 $(FILES_MODULE) $(PATH_INSTALL)

uninstall:
	cd $(PATH_INSTALL) && rm -f $(FILES_MODULE)
	cd $(PATH_INSTALL) && rm -f lua51.dll luajit.exe
	cd $(PATH_INSTALL) && rm -rf lua

.PHONY: help build clean install uninstall
