################################################################################
#
# LIBRETRO_FCEUMM
#
################################################################################
LIBRETRO_FCEUMM_DEPENDENCIES = retroarch
LIBRETRO_FCEUMM_DIR=$(BUILD_DIR)/libretro-fceumm

$(LIBRETRO_FCEUMM_DIR)/.source:
	mkdir -pv $(LIBRETRO_FCEUMM_DIR)
	cp -raf package/libretro-fceumm/src/* $(LIBRETRO_FCEUMM_DIR)
	touch $@

$(LIBRETRO_FCEUMM_DIR)/.configured : $(LIBRETRO_FCEUMM_DIR)/.source
	touch $@

libretro-fceumm-binary: $(LIBRETRO_FCEUMM_DIR)/.configured $(LIBRETRO_FCEUMM_DEPENDENCIES)
	BASE_DIR="$(BASE_DIR)" CFLAGS="$(TARGET_CFLAGS) -I${STAGING_DIR}/usr/include/ -I$(LIBRETRO_FCEUMM_DIR)/" CXXFLAGS="$(TARGET_CXXFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" $(MAKE) -C $(LIBRETRO_FCEUMM_DIR)/ -f Makefile.libretro platform="allwinner-h6"

libretro-fceumm: libretro-fceumm-binary
	mkdir -p $(TARGET_DIR)/usr/lib/libretro
	cp -raf $(LIBRETRO_FCEUMM_DIR)/fceumm_libretro.so $(TARGET_DIR)/usr/lib/libretro/
	$(TARGET_STRIP) $(TARGET_DIR)/usr/lib/libretro/fceumm_libretro.so

ifeq ($(BR2_PACKAGE_LIBRETRO_FCEUMM), y)
TARGETS += libretro-fceumm
endif
