APPS=hello_c/hello_c hello_cpp/hello_cpp hello_a_c/hello_a_c hello_a_cpp/hello_a_cpp hello_so_c/hello_so_c hello_so_cpp/hello_so_cpp
ARCHIVES=hello_a/hello.a
LIBS=hello_so/libhello.so

include defaults.mk

default: all

include $(foreach APP,$(APPS),$(APP).mk)
include $(foreach ARCHIVE,$(ARCHIVES),$(ARCHIVE).mk)
include $(foreach LIB,$(LIBS),$(LIB).mk)

all: $(APPS) $(ARCHIVES) $(LIBS)

include rules.mk

%.d: ;
PRECIOUS: %.d

-include $(foreach APP,$(APPS),$($(APP)_DEPS))
-include $(foreach ARCHIVE,$(ARCHIVES),$($(ARCHIVE)_DEPS))
-include $(foreach LIB,$(LIBS),$($(LIB)_DEPS))
