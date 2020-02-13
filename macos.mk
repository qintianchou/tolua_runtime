FILES_MODULE = cjson.so int64.so uint64.so
INSTALL_MODULE = /usr/local/lib/lua/5.1

help:
	@echo targets: build clean install uninstall

build: clean
	# 编译luajit解释器
	$(MAKE) -C luajit-2.1 MACOSX_DEPLOYMENT_TARGET=10.14

	# 编译lua模块cjson
	gcc -Os -Wall -fPIC -shared \
		luajit-2.1/src/libluajit.so \
		cjson/strbuf.c \
		cjson/lua_cjson.c \
		cjson/fpconv.c \
		-o cjson.so \
		-Iluajit-2.1/src \
		-Icjon

	# 编译lua模块int64
	gcc -Os -Wall -fPIC -shared \
		luajit-2.1/src/libluajit.so \
		int64.c \
		-o int64.so \
		-Iluajit-2.1/src

	# 编译lua模块uint64
	gcc -Os -Wall -fPIC -shared \
		luajit-2.1/src/libluajit.so \
		int64.c \
		uint64.c \
		-o uint64.so \
		-Iluajit-2.1/src

clean:
	$(MAKE) -C luajit-2.1 clean
	rm -f $(FILES_MODULE)

install: uninstall
	$(MAKE) -C luajit-2.1 install
	install -m 0644 $(FILES_MODULE) $(INSTALL_MODULE)

uninstall:
	$(MAKE) -C luajit-2.1 uninstall

.PHONY: help build clean install uninstall
