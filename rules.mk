Q=@
ifeq ($(V),1)
Q=
endif

CC=gcc
CFLAGS=-Wall -Wextra -std=c11

CXX=g++
CXXFLAGS=-Wall -Wextra -Weffc++ -std=c++17

LD=gcc
LDFLAGS=

include $(foreach APP,$(APPS),$(APP).mk)
include $(foreach ARCHIVE,$(ARCHIVES),$(ARCHIVE).mk)
include $(foreach LIB,$(LIBS),$(LIB).mk)

define app_rule
$1: $($1_OBJS)
	@echo "LD: $1"
	$(Q)$(LD) -o $1 $($1_OBJS) $($1_LDFLAGS)
endef

define archive_rule
$1: $($1_OBJS)
	@echo "ARCHIVE: $1"
	$(Q)$(AR) -ru $1 $($1_OBJS)
endef

define shared_object_rule
$1: $($1_OBJS)
	@echo "SHARED OBJECT: $1"
	$(Q)$(LD) -shared -o $1 $($1_OBJS) $($1_LDFLAGS)
endef

define c_obj_rule
$1.o: $1 $1.d
	@echo "C: $1"
	$(Q)$(CC) -c -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

define cxx_obj_rule
$1.o: $1 $1.d
	@echo "C++: $1"
	$(Q)$(CXX) -c -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CXXFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

define c_lib_obj_rule
$1.o: $1 $1.d
	@echo "C: $1"
	$(Q)$(CC) -c -fPIC -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

define cxx_lib_obj_rule
$1.o: $1 $1.d
	@echo "C++: $1"
	$(Q)$(CXX) -c -fPIC -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CXXFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

clean: $(foreach ARCHIVE,$(ARCHIVES),$(addprefix clean_,$(notdir $(ARCHIVE))))

clean: $(foreach LIB,$(LIBS),$(addprefix clean_,$(notdir $(LIB))))

clean: $(foreach APP,$(APPS),$(addprefix clean_,$(notdir $(APP))))

clean:
	@echo "CLEAN"
	$(Q)rm -rf *.d *.Td *.o $(APPS) $(ARCHIVES) $(LIBS)

ifneq ($(APPS),)
$(foreach APP,$(APPS),$(eval $(call app_rule,$(APP))))
$(foreach APP,$(APPS),$(foreach SRC,$($(APP)_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(APP)))))
$(foreach APP,$(APPS),$(foreach SRC,$($(APP)_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(APP)))))
-include $(foreach APP,$(APPS),$($(APP)_DEPS))
endif

ifneq ($(ARCHIVES),)
$(foreach ARCHIVE,$(ARCHIVES),$(eval $(call archive_rule,$(ARCHIVE))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(ARCHIVE)_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(ARCHIVE)))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(ARCHIVE)_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(ARCHIVE)))))
-include $(foreach ARCHIVE,$(ARCHIVES),$($(ARCHIVE)_DEPS))
endif

ifneq ($(LIBS),)
$(foreach LIB,$(LIBS),$(eval $(call shared_object_rule,$(LIB))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(LIB)_CSRCS),$(eval $(call c_lib_obj_rule,$(SRC),$(LIB)))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(LIB)_CXXSRCS),$(eval $(call cxx_lib_obj_rule,$(SRC),$(LIB)))))
-include $(foreach LIB,$(LIBS),$($(LIB)_DEPS))
endif

%.d: ;
PRECIOUS: %.d
