#
# rules.mk contains all the functions and evaluations for building the apps,
# libs and archives defined in the top-level Makefile.
# Each app, lib and archive has their own set of definitions and
# dependencies on what to build and how to build them based on the compiler
# flags.
# See LICENSE for usage terms.

# makefile_rules installation directory
MAKEFILE_RULES_DIR:=$(dir $(filter %rules.mk,$(MAKEFILE_LIST)))

# By default, make all the builds silent
Q=@
ifeq ($(V),1)
Q=
endif

WARNINGS:=-Wall -Wextra -Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict -Wnull-dereference -Wshadow

CFLAGS+=$(WARNINGS) -Wstrict-prototypes -Wjump-misses-init -Wformat=2 -std=c17
CXXFLAGS+=$(WARNINGS) -Wold-style-cast -Wuseless-cast -std=c++17

ifeq (1,$(SANITIZE))
CFLAGS+=-ggdb -fno-omit-frame-pointer
CFLAGS+=-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=pointer-compare -fsanitize=pointer-subtract

CXXFLAGS+=-ggdb -fno-omit-frame-pointer
CXXFLAGS+=-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=pointer-compare -fsanitize=pointer-subtrace

LDFLAGS+=-fsanitize=address -fsanitize=leak -fsanitize=undefined -fsanitize=pointer-compare -fsanitize=pointer-subtract
endif

ifeq (1,$(COVERAGE))
CFLAGS+=--coverage
CXXFLAGS+=--coverage
LDFLAGS+=--coverage
endif

ARFLAGS=cr

# Include each set of definitions and dependencies for APPS,
# LIBS and ARCHIVES defined in the top-level Makefile
include $(foreach APP,$(APPS),$(APP).mk)
include $(foreach ARCHIVE,$(ARCHIVES),$(ARCHIVE).mk)
include $(foreach LIB,$(LIBS),$(LIB).mk)

define pprintf
@printf "%20s: %s\n" "$1" "$2"
endef

# Helper function to use the specified C compiler if defined,
# else use the default one.
cc = $(if $($(notdir $1)_CC),$($(notdir $1)_CC),$(CC))

# Helper function to use the specified C++ compiler if defined,
# else use the default one.
cxx = $(if $($(notdir $1)_CXX),$($(notdir $1)_CXX),$(CXX))

# Helper function to use the specified linker if defined,
# else use the default one.
ld = $(if $($(notdir $1)_LD),$($(notdir $1)_LD),$(LD))

# Helper function to use the specified archiver if defined,
# else use the default one.
ar = $(if $($(notdir $1)_AR),$($(notdir $1)_AR),$(AR))

# Function to generate a specific rule for building each application
define link_rule
$1: $($(notdir $1)_OBJS)
	$(call pprintf,"LD",$1)
	$(Q)$(call ld,$1) -o $1 $($(notdir $1)_OBJS) $($(notdir $1)_LDFLAGS) $(LDFLAGS) $2
endef

# Function to generate a specific rule for creating each archive
define archive_rule
$1: $($(notdir $1)_OBJS)
	$(call pprintf,"ARCHIVE",$1)
	$(Q)$(call ar,$1) $(ARFLAGS) $1 $($(notdir $1)_OBJS)
endef

# Function to generate a specific rule to create each object file and the
# dependencies for regenerating said object file based on the C source
define c_obj_rule
$1.$2.o $1.$2.d: $1
	$(call pprintf,"C",$1)
	$(Q)$(call cc,$2) -c -o $1.$2.o $1 -MT $1.$2.o -MMD -MP -MF $1.$2.d $($(notdir $2)_CFLAGS) $(CFLAGS) $3
endef

# Function to generate a specific rule to create each object file and the
# dependencies for regenerating said object file based on the C++ source
define cxx_obj_rule
$1.$2.o $1.$2.d: $1
	$(call pprintf,"C++",$1)
	$(Q)$(call cxx,$2) -c -o $1.$2.o $1 -MT $1.$2.o -MMD -MP -MF $1.$2.d $($(notdir $2)_CXXFLAGS) $(CXXFLAGS) $3
endef

# Function to generate a specific rule to clean up generated objects and
# dependencies of a build target
define clean_rule
clean_$1:
	$(call pprintf,"CLEAN",$1)
	$(Q)rm -f $($1_OBJS) $($1_DEPS)
endef

clean:
	@printf "%20s\n" "CLEAN"
	$(Q)rm -rf *.d *.o $(APPS) $(ARCHIVES) $(LIBS)

# If there are any applications defined in the top-level Makefile, evaluate all
# required functions for each of these applications and add each clean
# target to the global CLEAN target as a dependency
ifneq ($(APPS),)

$(foreach APP,$(notdir $(APPS)),$(eval $(APP)_OBJS=$(addsuffix .$(APP).o,$($(APP)_CSRCS) $($(APP)_CXXSRCS))))
$(foreach APP,$(notdir $(APPS)),$(eval $(APP)_DEPS=$(addsuffix .$(APP).d,$($(APP)_CSRCS) $($(APP)_CXXSRCS))))

$(foreach APP,$(APPS),$(eval $(call link_rule,$(APP),)))
$(foreach APP,$(APPS),$(foreach SRC,$($(notdir $(APP))_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(notdir $(APP)),))))
$(foreach APP,$(APPS),$(foreach SRC,$($(notdir $(APP))_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(notdir $(APP)),))))
# Include dependencies for each application object file
include $(foreach APP,$(APPS),$($(notdir $(APP))_DEPS))
clean: $(foreach APP,$(APPS),$(addprefix clean_,$(notdir $(APP))))

$(foreach APP,$(notdir $(APPS)),$(eval $(call clean_rule,$(APP))))

endif

# If there are any archives defined in the top-level Makefile, evaluate all
# required functions for each of these archives and add each clean target
# to the global CLEAN target as a dependency
ifneq ($(ARCHIVES),)

$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(ARCHIVE)_OBJS=$(addsuffix .$(ARCHIVE).o,$($(ARCHIVE)_CSRCS) $($(ARCHIVE)_CXXSRCS))))
$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(ARCHIVE)_DEPS=$(addsuffix .$(ARCHIVE).d,$($(ARCHIVE)_CSRCS) $($(ARCHIVE)_CXXSRCS))))

$(foreach ARCHIVE,$(ARCHIVES),$(eval $(call archive_rule,$(ARCHIVE))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(notdir $(ARCHIVE))_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(notdir $(ARCHIVE)),))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(notdir $(ARCHIVE))_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(notdir $(ARCHIVE)),))))
# Include dependencies for each archive object file
include $(foreach ARCHIVE,$(ARCHIVES),$($(notdir $(ARCHIVE))_DEPS))
clean: $(foreach ARCHIVE,$(ARCHIVES),$(addprefix clean_,$(notdir $(ARCHIVE))))

$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(call clean_rule,$(ARCHIVE))))

endif

# If there are any libraries (shared objects) defined in the top-level Makefile,
# evaluate all required functions for each of these libraries and add each clean
# target to the global CLEAN target as a dependency
ifneq ($(LIBS),)

$(foreach LIB,$(notdir $(LIBS)),$(eval $(LIB)_OBJS=$(addsuffix .$(LIB).o,$($(LIB)_CSRCS) $($(LIB)_CXXSRCS))))
$(foreach LIB,$(notdir $(LIBS)),$(eval $(LIB)_OBJS=$(addsuffix .$(LIB).o,$($(LIB)_CSRCS) $($(LIB)_CXXSRCS))))

$(foreach LIB,$(LIBS),$(eval $(call link_rule,$(LIB),-shared)))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(notdir $(LIB))_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(notdir $(LIB)),-fPIC))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(notdir $(LIB))_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(notdir $(LIB)),-fPIC))))
# Include dependencies for each library object file
include $(foreach LIB,$(LIBS),$($(notdir $(LIB))_DEPS))
clean: $(foreach LIB,$(LIBS),$(addprefix clean_,$(notdir $(LIB))))

$(foreach LIB,$(notdir $(LIBS)),$(eval $(call clean_rule,$(LIB))))

endif

# The dependency files are generated as a byproduct of the compilation of the
# source files. Preserve them once compilation is finished.
PRECIOUS: %.d
