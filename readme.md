---
typora-root-url: assets
---

## 一些工作中用到的常用库的交叉编译脚本
### 目前已有如下版本


#### libffi-3.2.1    

```shell
./configure --prefix=$RESULT_DIR/libffi-3.2.1/ --host=$HOST CC=$CROSS_CC CXX=$CROSS_CXX --enable-shared
```

ps：交叉编译时只需配置 prefix，host，CC，CXX，若需要动态库则需开启 --enable-shared

#### zlib-1.2.11

```shell
export CC=$CROSS_CC 
./configure --prefix=$RESULT_DIR/zlib-1.2.11/ 
```

ps：./configure无CC选项，交叉编译时需手动导入CC

#### gettext-0.20

```shell
./configure --prefix=$RESULT_DIR/gettext-0.20/ --host=$HOST  CC=$CROSS_CC CXX=$CROSS_CXX \
            --enable-static \
```

#### glib-2.56.4     

```shell
echo glib_cv_long_long_format=ll >nxp.cache
echo glib_cv_stack_grows=no >> nxp.cache
echo glib_cv_have_strlcpy=no >> nxp.cache
echo glib_cv_have_qsort_r=yes >> nxp.cache
echo glib_cv_va_val_copy=yes >> nxp.cache
echo glib_cv_uscore=no >> nxp.cache
echo glib_cv_rtldglobal_broken=no >> nxp.cache
echo ac_cv_func_posix_getpwuid_r=yes >> nxp.cache
echo ac_cv_func_posix_getgrgid_r=yes >> nxp.cache
./configure --build=x86_64 --prefix=$RESULT_DIR/glib-2.56.4/ --host=$HOST  \
            CC=$CROSS_CC CXX=$CROSS_CXX \
            LIBFFI_CFLAGS="-I$RESULT_DIR/libffi-3.2.1/lib/libffi-3.2.1/include/" \
            LIBFFI_LIBS="-lffi -L$RESULT_DIR/libffi-3.2.1/lib/" \
            ZLIB_CFLAGS="-I$RESULT_DIR/zlib-1.2.11/include" \
            ZLIB_LIBS="-lz -L$RESULT_DIR/zlib-1.2.11/lib" \
            CFLAGS=" -I$RESULT_DIR/gettext-0.20/include" \
            LDFLAGS="-lintl -L$RESULT_DIR/gettext-0.20/lib"\
            --disable-selinux --disable-xattr --disable-libelf --with-pcre=internal  --disable-libmount --disable-fam  \
            --cache-file=nxp.cache  \
```

ps：需注意若想编译lcm动态库，则glib需编译成静态库

#### lcm-1.3.0-saic  

lcm依赖问题

lcm依赖glib和gettext，glib依赖ffi、zlib、gettext，而如果要生成lcm动态库，则glib必须为静态库

![](/readme/LCM依赖关系图.jpg)

```shell
./configure --enable-shared=yes --enable-static=no \
            --build=x86_64 --host=$HOST --prefix=$RESULT_DIR/lcm-1.3.0-saic/ \
            --without-python --without-java --without-lua\
            CC=$CROSS_CC CXX=$CROSS_CXX \
            GLIB_CFLAGS=" -I$RESULT_DIR/glib-2.56.4/include/ -I$RESULT_DIR/glib-2.56.4/include/glib-2.0/ -I$RESULT_DIR/glib-2.56.4/lib/glib-2.0/include/" \
            GLIB_LIBS="$RESULT_DIR/glib-2.56.4/lib/libglib-2.0.a $RESULT_DIR/glib-2.56.4/lib/libgthread-2.0.a"\
            LIBS="$RESULT_DIR/gettext-0.20/lib/libintl.a -lpthread"
```

-----------------------------



#### zeromq-4.3.1

```shell
./configure --prefix=$RESULT_DIR/zeromq-4.3.1/  \
            --host=$HOST CC=$CROSS_CC CXX=$CROSS_CXX --enable-shared
```

--------------------



#### readline-6.3    

```shell
echo bash_cv_wcwidth_broken=yes > arm-linux.cache
./configure --prefix=$RESULT_DIR/readline-6.3/         \
            --host=$HOST CC=$CROSS_CC CXX=$CROSS_CXX   \
            --enable-shared --cache=arm-linux.cache && \
            make -j$MAKE_JOBS && \
            make install
```

#### lua-5.3.5       

```shell
rm -rf $RESULT_DIR/lua-5.3.5/*
cd $WORK_DIR/lua-5.3.5
make clean
if [ $HOST = "arm-hisiv500-linux" ];then
    export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/hisiv500
    echo "hisiv500"
elif [ $HOST = "aarch64-linux-gnu" ];then
    export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/s32v
    export s32v_path=$S32V_CROSS_TOOLCHAIN
    make echo&&make arm-s32v&&make install 
elif [ $HOST = "aarch64-gnu-linux" ];then
    export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/pegasus
    export pegasus_path=/home/user/0529nvidia/nvidia/nvidia_sdk/DRIVE/Linux/5.0.13.2/SW/DriveSDK/toolchains/tegra-4.9-nv/usr/bin/aarch64-gnu-linux
    make echo&&make arm-pegasus&&make install 
else
    echo "linux"
    export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/x86_64
    make linux&&make install 
fi
```

在内层MAKEFILE下添加如下代码

```shell
arm-s32v:
	$(MAKE) $(ALL) CC="$(s32v_path)/aarch64-linux-gnu-gcc" AR="$(s32v_path)/aarch64-linux-gnu-ar rcu" RANLIB="$(s32v_path)/aarch64-linux-gnu-ranlib" \
    SYSCFLAGS="-DLUA_USE_ARM_LINUX" SYSLIBS="-Wl,-E -ldl"
```

外层MakFile下修改代码为

```shell
INSTALL_TOP= $(LUA_INSTALL_PATH)
```

-------------------



#### protobuf-2.6.1  &&protobuf-3.5.1  

```shell
# 应用本机（x86）编译生成protoc等执行文件：
./configure --prefix=$RESULT_DIR/protobuf-2.6.1/x86 CC=$LOCAL_CC && \
            make -j$MAKE_JOBS && \
            make install      && \
            make distclean    && \
            make clean
# 应用交叉编译链进行交叉编译，替换protoc执行文件：
./configure --prefix=$RESULT_DIR/protobuf-2.6.1/arm --host=$HOST \
            CC=$CROSS_CC CXX=$CROSS_CXX  \
            --enable-shared  --with-protoc=$RESULT_DIR/protobuf-2.6.1/x86/bin/protoc &&\
            make -j$MAKE_JOBS && \
            make install
```

```shell
# 应用本机（x86）编译生成protoc等执行文件：
./configure --prefix=$RESULT_DIR/protobuf-3.5.1/x86 CC=$LOCAL_CC &&\
            make -j$MAKE_JOBS && \
            make install      && \
            make distclean    && \
            make clean
# 应用交叉编译链进行交叉编译，替换protoc执行文件：
./configure --prefix=$RESULT_DIR/protobuf-3.5.1/arm --host=$HOST \
            CC=$CROSS_CC CXX=$CROSS_CXX  \
            --enable-shared  --with-protoc=$RESULT_DIR/protobuf-3.5.1/x86/bin/protoc && \
            make -j$MAKE_JOBS && \
            make install
```



## 如何使用
只需将该脚本放置到 待编译源码 同级目录下即可；
生成的文件在 同级目录/result/包名 下