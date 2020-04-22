set -x
# configure toolchain
WORK_DIR=`pwd`
MAKE_JOBS=`cat /proc/cpuinfo | grep "processor" | wc -l`
RESULT_DIR=$WORK_DIR/result
LOCAL_CC=gcc
. /opt/fsl-imx-xwayland/4.14-sumo/environment-setup-aarch64-poky-linux
HOST=aarch64-poky-linux

# ########### begin compile #############
# rm -rf $RESULT_DIR/libffi-3.2.1/*
# cd $WORK_DIR/libffi-3.2.1 && make clean
# ./configure --prefix=$RESULT_DIR/libffi-3.2.1/  --host=$HOST --enable-shared \
#             && make -j$MAKE_JOBS \
#             && make install


# rm -rf $RESULT_DIR/zlib-1.2.11/*
# cd $WORK_DIR/zlib-1.2.11
# make clean
# ./configure --prefix=$RESULT_DIR/zlib-1.2.11/ \
#             --enable-shared \
#             && make -j$MAKE_JOBS \
#             && make install


# rm -rf $RESULT_DIR/gettext-0.20/*
# cd $WORK_DIR/gettext-0.20 && make clean
# ./configure --prefix=$RESULT_DIR/gettext-0.20/ --host=$HOST \
#             --enable-static \
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
#             --disable-selinux --disable-xattr --disable-libelf --with-pcre=internal  --disable-libmount --disable-fam  \
#             --cache-file=nxp.cache \
#             --enable-static \
#             && make -j$MAKE_JOBS \
#             && make install

# rm -rf $RESULT_DIR/lcm-1.3.0-saic/*
# cd $WORK_DIR/lcm-1.3.0-saic && make clean
# ./configure --enable-shared=yes --enable-static=yes \
#             --build=x86_64 --host=$HOST --prefix=$RESULT_DIR/lcm-1.3.0-saic/ \
#             --without-python --without-java --without-lua\
#             &&make -j$MAKE_JOBS \
#             &&make install

# ##########################################################################################################
LIBRARY_VERSION=("protobuf-2.6.1" "protobuf-3.3.0" "protobuf-3.5.1")
for VERSION in ${LIBRARY_VERSION[@]}
do
echo $VERSION
rm -rf $RESULT_DIR/$VERSION/*
CC_BAK=$CC
CXX_BAK=$CXX
export CC=
export CXX=
cd $WORK_DIR/$VERSION/ && make distclean && make clean
# 应用本机（x86）编译生成protoc等执行文件：
./configure --prefix=$RESULT_DIR/$VERSION/x86 CC=$LOCAL_CC && \
            make -j$MAKE_JOBS && \
            make install      && \
            make distclean    && \
            make clean
# 应用交叉编译链进行交叉编译，替换protoc执行文件：
export CC=$CC_BAK
export CXX=$CXX_BAK
./configure --prefix=$RESULT_DIR/$VERSION/arm --host=$HOST \
            --with-protoc=$RESULT_DIR/$VERSION/x86/bin/protoc &&\
            make -j$MAKE_JOBS && \
            make install
done 

# ############################################################################################################
# LIBRARY_VERSION=cryptopp-CRYPTOPP_8_1_0
# rm -rf $RESULT_DIR/$LIBRARY_VERSION/
# cd $WORK_DIR/$LIBRARY_VERSION/ && make distclean && make clean
# rm -rf GNUmakefile-cross
# make -j4 static dynamic 
# mkdir -p $RESULT_DIR/$LIBRARY_VERSION/lib  &&  mv libcryptopp.* $RESULT_DIR/$LIBRARY_VERSION/lib

# ############################################################################################################
# LIBRARY_VERSION=("zeromq-4.1.6" "zeromq-4.3.1")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION && make clean
# ./configure --prefix=$RESULT_DIR/$VERSION/  \
#             --host=$HOST --enable-shared &&\ 
#             make -j$MAKE_JOBS && \
#             make install
# done

# ############################################################################################################
# LIBRARY_VERSION=("cJSON-1.7.12")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# export PREFIX=$RESULT_DIR/$VERSION
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION && make clean
#     make CC="$CC" -j$MAKE_JOBS
#     make install 
# done


# ############################################################################################################
# LIBRARY_VERSION=("curl-7.64.1")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION && make clean
# ./configure --prefix=$RESULT_DIR/$VERSION/  \
#             --host=$HOST --enable-shared &&\ 
#             make -j$MAKE_JOBS && \
#             make install
# done

# ############################################################################################################
# LIBRARY_VERSION=("zstd-1.3.4")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION && make clean
# make -j$MAKE_JOBS && \
# mkdir -p $RESULT_DIR/$VERSION/lib  &&  mv ./lib/*zstd.* $RESULT_DIR/$VERSION/lib
# done

#############################################################################################################
# LIBRARY_VERSION=("boost_1_60_0")
# for VERSION in ${LIBRARY_VERSION[@]}
# do
# echo $VERSION
# rm -rf $RESULT_DIR/$VERSION/*
# cd $WORK_DIR/$VERSION 
# ./bootstrap.sh --with-toolset="$CC"
# # ./b2 --prefix=$RESULT_DIR/$VERSION/  \
# #             --host=$HOST --enable-shared &&\ 
# #             make -j$MAKE_JOBS && \
# #             make install
# done
# sed -i  "s#using gcc ;#using gcc :: $CC ;#" project-config.jam

# #############################################################################################################
# # 多版本编译测试
# # arr=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "e" "e" "f")
# # for value in ${arr[@]}
# # do
# # echo $value
# # done
# #############################################################################################################

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
# elif [ $HOST = "aarch64-poky-linux" ];then
#     export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/imx8
#     export imx8_path=/opt/fsl-imx-xwayland/4.14-sumo/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux
#     export imx8_sysroot_path=/opt/fsl-imx-xwayland/4.14-sumo/sysroots/aarch64-poky-linux
#     make echo&&make arm-imx8 && make install 
# else
#     echo "linux"
#     export LUA_INSTALL_PATH=$RESULT_DIR/lua-5.3.5/x86_64
#     make linux&&make install 
# fi

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


# 
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

