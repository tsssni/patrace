
LOCAL_PATH:=$(call my-dir)/../../../../src

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
PA_BUILD_64BIT := -DPLATFORM_64BIT
else
PA_BUILD_64BIT :=
endif

################################################################
# Target: Single gles layer
include $(CLEAR_VARS)

LOCAL_MODULE       := libGLES_layer_$(TARGET_ARCH)

LOCAL_SRC_FILES    := \
    common/os_posix.cpp \
    fakedriver/common.cpp \
    fakedriver/egl/fps_log.cpp \
    fakedriver/single/auto.cpp \
    fakedriver/single/proc.cpp \
    dispatch/gleslayer_helper.cpp \
    dispatch/eglproc_trace.cpp \
    dispatch/eglproc_auto.cpp

LOCAL_C_INCLUDES:= \
    $(LOCAL_PATH) \
    $(LOCAL_PATH)/common \
    $(LOCAL_PATH)/../../thirdparty/opengl-registry/api \
    $(LOCAL_PATH)/../../thirdparty/egl-registry/api \
    $(LOCAL_PATH)/../../thirdparty/opencl-headers \
    $(LOCAL_PATH)/fakedriver/egl

LOCAL_CFLAGS    := -O3 -D__arm__ -D__gnu_linux__ -DGLESLAYER $(PA_BUILD_64BIT) -fvisibility=hidden -Wno-attributes
LOCAL_LDLIBS    := -nodefaultlibs -lc -lm -lz -llog -ldl
LOCAL_CPPFLAGS  += -std=c++14
LOCAL_CFLAGS_arm += -U__ARM_ARCH_5__ -U__ARM_ARCH_5T__ \
	      -U__ARM_ARCH_5E__ -U__ARM_ARCH_5TE__ \
	      -march=armv7-a -mfpu=vfp

LOCAL_LDFLAGS   += -Wl,-z,max-page-size=16384
include $(BUILD_SHARED_LIBRARY)
