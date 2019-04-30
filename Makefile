APPS=hello_c/hello_c hello_cpp/hello_cpp hello_a_c/hello_a_c hello_a_cpp/hello_a_cpp hello_so_c hello_so_cpp
ARCHIVES=hello_a/hello.a
LIBS=hello_so/libhello.so

CC=gcc
CFLAGS=-Wall -Wextra -std=c11

CXX=g++
CXXFLAGS=-Wall -Wextra -Weffc++ -std=c++17

LD=gcc
LDFLAGS=

Q=@
ifeq ($(V),1)
Q=
endif

default: all

include $(foreach APP,$(APPS),$(APP).mk)
include $(foreach ARCHIVE,$(ARCHIVES),$(ARCHIVE).mk)
include $(foreach LIB,$(LIBS),$(LIB).mk)

all: $(APPS) $(ARCHIVES) $(LIBS)

include rules.mk

$(foreach APP,$(APPS),$(eval $(call app_rule,$(APP))))
$(foreach APP,$(APPS),$(foreach SRC,$($(APP)_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(APP)))))
$(foreach APP,$(APPS),$(foreach SRC,$($(APP)_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(APP)))))

$(foreach ARCHIVE,$(ARCHIVES),$(eval $(call archive_rule,$(ARCHIVE))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(ARCHIVE)_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(ARCHIVE)))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(ARCHIVE)_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(ARCHIVE)))))

$(foreach LIB,$(LIBS),$(eval $(call shared_object_rule,$(LIB))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(LIB)_CSRCS),$(eval $(call c_lib_obj_rule,$(SRC),$(LIB)))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(LIB)_CXXSRCS),$(eval $(call cxx_lib_obj_rule,$(SRC),$(LIB)))))

%.d: ;
PRECIOUS: %.d

-include $(foreach APP,$(APPS),$($(APP)_DEPS))
-include $(foreach ARCHIVE,$(ARCHIVES),$($(ARCHIVE)_DEPS))
-include $(foreach LIB,$(LIBS),$($(LIB)_DEPS))
