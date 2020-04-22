set -x
# configure toolchain
WORK_DIR=`pwd`
MAKE_JOBS=`cat /proc/cpuinfo | grep "processor" | wc -l`
RESULT_DIR=$WORK_DIR/result
LOCAL_CC=gcc
CROSS_CC=/opt/0529nvidia/nvidia/nvidia_sdk/DRIVE/Linux/5.0.13.2/SW/DriveSDK/toolchains/tegra-4.9-nv/usr/bin/aarch64-gnu-linux/aarch64-gnu-linux-gcc
CROSS_CXX=/opt/0529nvidia/nvidia/nvidia_sdk/DRIVE/Linux/5.0.13.2/SW/DriveSDK/toolchains/tegra-4.9-nv/usr/bin/aarch64-gnu-linux/aarch64-gnu-linux-g++

# toolchain--> host
# hisiv500 --> arm-hisiv500-linux
# s32v     --> aarch64-linux-gnu
# pegasus  --> aarch64-gnu-linux
HOST=aarch64-gnu-linux

############################################################################################################

LIBRARY_VERSION=("opencv-2.4.13.2")
for VERSION in ${LIBRARY_VERSION[@]}
do
echo $VERSION
rm -rf $RESULT_DIR/$VERSION/* && rm -rf $WORK_DIR/$VERSION/build/
cd $WORK_DIR/$VERSION && mkdir build  && cd build
pwd
cmake -DCMAKE_C_COMPILER=$CROSS_CC -DCMAKE_CXX_COMPILER=$CROSS_CXX  -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=$RESULT_DIR/$VERSION ..
make -j$MAKE_JOBS && \
make install
done


# rm -rf $RESULT_DIR/libffi-3.2.1/*
# cd $WORK_DIR/libffi-3.2.1 && make clean
# ./configure --prefix=$RESULT_DIR/libffi-3.2.1/  --host=$HOST CC=$CROSS_CC CXX=$CROSS_CXX --enable-shared \
#             && make -j$MAKE_JOBS \
#             && make install

# rm -rf $RESULT_DIR/zlib-1.2.11/*
# cd $WORK_DIR/zlib-1.2.11
# export CC=$CROSS_CC
# make clean
# ./configure --prefix=$RESULT_DIR/zlib-1.2.11/ \
#             --enable-shared \
#             && make -j$MAKE_JOBS \
#             && make install


# rm -rf $RESULT_DIR/glib-2.56.4/*
# cd $WORK_DIR/glib-2.56.4 && make clean
# echo glib_cv_long_long_format=ll >nxp.cache
# echo glib_cv_stack_grows=no >> nxp.cache
# echo glib_cv_have_strlcpy=no >> nxp.cache
# echo glib_cv_have_qsort_r=yes >> nxp.cache
# echo glib_cv_va_val_copy=yes >> nxp.cache
# echo glib_cv_uscore=no >> nxp.cache
# echo glib_cv_rtldglobal_broken=no >> nxp.cache
# echo ac_cv_func_posix_getpwuid_r=yes >> nxp.cache
# echo ac_cv_func_posix_getgrgid_r=yes >> nxp.cache
# ./configure --prefix=$RESULT_DIR/glib-2.56.4/ --host=$HOST  \
#             CC=$CROSS_CC \
#             LIBFFI_CFLAGS="-I$RESULT_DIR/libffi-3.2.1/lib/libffi-3.2.1/include/" \
#             LIBFFI_LIBS="-lffi -L$RESULT_DIR/libffi-3.2.1/lib/" \
#             ZLIB_CFLAGS="-I$RESULT_DIR/zlib-1.2.11/include" \
#             ZLIB_LIBS="-lz -L$RESULT_DIR/zlib-1.2.11/lib" \
#             --disable-selinux --disable-xattr --disable-libelf --with-pcre=internal  --disable-libmount --disable-fam  \
#             --enable-static\
#             --cache-file=nxp.cache  \
#             && make -j$MAKE_JOBS \
#             && make install

# rm -rf $RESULT_DIR/lcm-1.3.0-saic/*
# cd $WORK_DIR/lcm-1.3.0-saic && make clean
# ./configure --enable-shared=no --enable-static=yes \
#             --build=x86_64 --host=$HOST --prefix=$RESULT_DIR/lcm-1.3.0-saic/ \
#             --without-python --without-java --without-lua\
#             CC=$CROSS_CC CXX=$CROSS_CXX \
#             GLIB_CFLAGS="-I$RESULT_DIR/glib-2.56.4/include/ -I$RESULT_DIR/glib-2.56.4/include/glib-2.0/ -I$RESULT_DIR/glib-2.56.4/lib/glib-2.0/include/" \
#             GLIB_LIBS="-L$RESULT_DIR/glib-2.56.4/lib/ -lglib-2.0 -lgthread-2.0"\
#             LIBS="-lpthread"\
#             &&make -j$MAKE_JOBS \
#             &&make install

# ##########################################################################################################
# LIBRARY_VERSION=("protobuf-2.6.1" "protobuf-3.3.0" "protobuf-3.5.1")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# LIBRARY_VERSION=protobuf-3.3.0
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION/ && make distclean && make clean
# # 应用本机（x86）编译生成protoc等执行文件：
# ./configure --prefix=$RESULT_DIR/$VERSION/x86 CC=$LOCAL_CC && \
#             make -j$MAKE_JOBS && \
#             make install      && \
#             make distclean    && \
#             make clean
# # 应用交叉编译链进行交叉编译，替换protoc执行文件：
# ./configure --prefix=$RESULT_DIR/$VERSION/arm --host=$HOST \
#             CC=$CROSS_CC CXX=$CROSS_CXX  \
#             --enable-shared  --with-protoc=$RESULT_DIR/$VERSION/x86/bin/protoc &&\
#             make -j$MAKE_JOBS && \
#             make install
# done

############################################################################################################
# LIBRARY_VERSION=cryptopp-CRYPTOPP_8_1_0
# rm -rf $RESULT_DIR/$LIBRARY_VERSION/
# cd $WORK_DIR/$LIBRARY_VERSION/ && make distclean && make clean
# rm -rf GNUmakefile-cross
# make CC=$CROSS_CC CXX=$CROSS_CXX  \
#      CXXFLAGS="-DNDEBUG -mfloat-abi=softfp -mfpu=neon" -j4 static dynamic 
# mkdir -p $RESULT_DIR/$LIBRARY_VERSION/lib  &&  mv libcryptopp.* $RESULT_DIR/$LIBRARY_VERSION/lib

############################################################################################################
# LIBRARY_VERSION=("zeromq-4.1.6" "zeromq-4.3.1")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION && make clean
# ./configure --prefix=$RESULT_DIR/zeromq-4.3.1/  \
#             --host=$HOST CC=$CROSS_CC CXX=$CROSS_CXX --enable-shared &&\ 
#             make -j$MAKE_JOBS && \
#             make install
# done

############################################################################################################
# rm -rf $RESULT_DIR/lua-5.3.5/*
# cd $WORK_DIR/lua-5.3.5
# make clean
# if [ $HOST = "arm-hisiv500-linux" ];then
#     export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/hisiv500
#     echo "hisiv500"
# elif [ $HOST = "aarch64-linux-gnu" ];then
#     export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/s32v
#     export s32v_path=$S32V_CROSS_TOOLCHAIN
#     make echo&&make arm-s32v&&make install 
# elif [ $HOST = "aarch64-gnu-linux" ];then
#     export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/pegasus
#     export pegasus_path=/home/user/0529nvidia/nvidia/nvidia_sdk/DRIVE/Linux/5.0.13.2/SW/DriveSDK/toolchains/tegra-4.9-nv/usr/bin/aarch64-gnu-linux
#     make echo&&make arm-pegasus&&make install 
# else
#     echo "linux"
#     export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/x86_64
#     make linux&&make install 
# fi

############################################################################################################
# rm -rf $RESULT_DIR/swig-4.0.1/*
# cd $WORK_DIR/swig-4.0.1 && make clean
# ./autogen.sh
# ./configure --prefix=$RESULT_DIR/swig-4.0.1/ CC=$LOCAL_CC  \
#             --without-pcre && \
#             make -j$MAKE_JOBS && \
#             make install

# rm -rf $RESULT_DIR/readline-6.3/*
# cd $WORK_DIR/readline-6.3 && make clean
# echo bash_cv_wcwidth_broken=yes > arm-linux.cache
# ./configure --prefix=$RESULT_DIR/readline-6.3/         \
#             --host=$HOST CC=$CROSS_CC CXX=$CROSS_CXX   \
#             --enable-shared --cache=arm-linux.cache && \
#             make -j$MAKE_JOBS && \
#             make install


# cd $WORK_DIR/openpgm-5-1-118/openpgm/pgm/
# ./bootstrap.sh
# make clean
# ./configure --prefix=$RESULT_DIR/openpgm-5-1-118/ --host=$HOST CC=$CROSS_CC
# make install

# cd $WORK_DIR/libpgm-5.2.122~dfsg/openpgm/pgm/
# ./bootstrap.sh
# make clean
# ./configure --prefix=$RESULT_DIR/libpgm-5.2.122~dfsg/ --host=$HOST CC=$CROSS_CC ac_cv_file__proc_cpuinfo=yes ac_cv_file__dev_rtc=no ac_cv_file__dev_hpet=no 
# make -j$MAKE_JOBS
# make install

