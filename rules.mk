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

WARNINGS:=-Wall -Wextra -Wduplicated-cond -Wduplicated-branches -Wlogical-op
WARNINGS+=-Wnull-dereference -Wdouble-promotion -Wshadow -Wparentheses
WARNINGS+=-Wformat=2 -Wformat-overflow=2

CC_STD?=c17
CXX_STD?=c++17

C_WARNINGS+=$(WARNINGS) -Wstrict-prototypes -Wjump-misses-init -std=$(CC_STD)
CXX_WARNINGS+=$(WARNINGS) -Wold-style-cast -Wuseless-cast -std=$(CXX_STD)

CFLAGS:=$(C_WARNINGS) -fdata-sections -ffunction-sections $(ADDITIONAL_CFLAGS)
CXXFLAGS:=$(CXX_WARNINGS) -fdata-sections -ffunction-sections $(ADDITIONAL_CXXFLAGS)
LDFLAGS:=$(ADDITIONAL_LDFLAGS)

DEBUG_CFLAGS+=-fno-omit-frame-pointer -g3 -Og
DEBUG_CXXFLAGS+=-fno-omit-frame-pointer -g3 -Og
DEBUG_LDFLAGS+=

RELEASE_CFLAGS+=-fomit-frame-pointer -O3 -flto -ffat-lto-objects
RELEASE_CXXFLAGS+=-fomit-frame-pointer -O3 -flto -ffat-lto-objects
RELEASE_LDFLAGS+=-flto -ffat-lto-objects

ifeq (1,$(RELEASE))
CFLAGS+=$(RELEASE_CFLAGS)
CXXFLAGS+=$(RELEASE_CXXFLAGS)
LDFLAGS+=$(RELEASE_LDFLAGS)
else
CFLAGS+=$(DEBUG_CFLAGS)
CXXFLAGS+=$(DEBUG_CXXFLAGS)
LDFLAGS+=$(DEBUG_LDFLAGS)
endif

ifeq (1,$(SANITIZE))
CFLAGS+=-fsanitize=address,leak,undefined,pointer-compare,pointer-subtract
CXXFLAGS+=-fsanitize=address,leak,undefined,pointer-compare,pointer-subtract
LDFLAGS+=-fsanitize=address,leak,undefined,pointer-compare,pointer-subtract
endif

ifeq (1,$(COVERAGE))
CFLAGS+=--coverage
CXXFLAGS+=--coverage
LDFLAGS+=--coverage
endif

ARFLAGS=cr

## Pretty print function
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

# Helper function to use the specified objcopy if defined,
# else use the default one.
OBJCOPY?=objcopy
objcopy = $(if $($(notdir $1)_OBJCOPY),$($(notdir $1)_OBJCOPY),$(OBJCOPY))

# Helper function to use the specified size if defined,
# else use the default one.
SIZE?=size
size = $(if $($(notdir $1)_SIZE),$($(notddir $1)_SIZE),$(SIZE))

# Function to generate a specific rule for building an application
define app_rule
$1: $($(notdir $1)_OBJS)
	$(Q)$(call ld,$1) -o $1 $($(notdir $1)_OBJS) $($(notdir $1)_LDFLAGS) $(LDFLAGS)
	@printf "%20s: %s ...\n" "LD" "$1"
	$(Q)$(call size,$1) -t $1 | tail -n 1 | awk '{ printf "%20s: %s (text: %d, data: %d, bss: %d)\n", "LD", "$1", $$$$1, $$$$2, $$$$3 }'
endef

# Function to generate a specific rule for building a shared library
define shared_lib_rule
$1: $($(notdir $1)_OBJS)
	$(Q)$(call ld,$1) -o $1 $($(notdir $1)_OBJS) $($(notdir $1)_LDFLAGS) $(LDFLAGS) -shared
	@printf "%20s: %s ...\n" "LD" "$1"
	$(Q)$(call size,$1) -t $1 | tail -n 1 | awk '{ printf "%20s: %s (text: %d, data: %d, bss: %d)\n", "LD", "$1", $$$$1, $$$$2, $$$$3 }'
endef

# Function to generate a specific rule for building an archive
define archive_rule
$1: $($(notdir $1)_OBJS)
	$(Q)$(call ar,$1) $(ARFLAGS) $1 $($(notdir $1)_OBJS)
	@printf "%20s: %s ...\n" "AR" "$1"
	$(Q)$(call size,$1) -t $1 | tail -n 1 | awk '{ printf "%20s: %s (text: %d, data: %d, bss: %d)\n", "AR", "$1", $$$$1, $$$$2, $$$$3 }'
endef

# Function to generate a specific rule to create each object file and the
# dependencies for regenerating the object file based on the C source
define c_obj_rule
$1.$2.o $1.$2.d: $1
	$(Q)$(call cc,$2) -c -o $1.$2.o $1 -MT $1.$2.o -MMD -MP -MF $1.$2.d $($(notdir $2)_CFLAGS) $(CFLAGS) $3
	@printf "%20s: %s ...\n" "C" "$1"
	$(Q)$(call size,$2) -t $1.$2.o | tail -n 1 | awk '{ printf "%20s: %s (text: %d, data: %d, bss: %d)\n", "C", "$1", $$$$1, $$$$2, $$$$3 }'
endef

# FUnction to generate a specific rule to create each object file and the
# dependencies for regenerating the object file based on the C++ source
define cxx_obj_rule
$1.$2.o $1.$2.d: $1
	$(Q)$(call cxx,$2) -c -o $1.$2.o $1 -MT $1.$2.o -MMD -MP -MF $1.$2.d $($(notdir $2)_CXXFLAGS) $(CXXFLAGS) $3
	@printf "%20s: %s ...\n" "C++" "$1"
	$(Q)$(call size,$2) -t $1.$2.o | tail -n 1 | awk '{ printf "%20s: %s (text: %d, data: %d, bss: %d)\n", "C++", "$1", $$$$1, $$$$2, $$$$3 }'
endef

# Functio nto generate a specific rule to clean up generated objects and
# dependencies for a specified build target
define clean_rule
clean_$1:
	@printf "%20s: %s\n" "CLEAN" "$1"
	$(Q)rm -f $($1_OBJS) $($1_DEPS) $($1_COVERAGE)
endef

# Include each set of definitions and dependencies for APPS,
# LIBS and ARCHIVES defined in the top-level Makefile
include $(foreach APP,$(APPS),$(APP).mk)
include $(foreach ARCHIVE,$(ARCHIVES),$(ARCHIVE).mk)
include $(foreach LIB,$(LIBS),$(LIB).mk)

clean:
	@printf "%20s\n" "CLEAN"
	$(Q)rm -rf $(APPS) $(ARCHIVES) $(LIBS)

# If there are any applications defined in the top-level Makefile, evaluate all
# required functions for each of these applications and add each clean
# target to the global CLEAN target as a dependency
ifneq ($(APPS),)
# Generate variables for $(APP) objects and dependencies.
$(foreach APP,$(notdir $(APPS)),$(eval $(APP)_OBJS=$(addsuffix .$(APP).o,$($(APP)_CSRCS) $($(APP)_CXXSRCS))))
$(foreach APP,$(notdir $(APPS)),$(eval $(APP)_DEPS=$(addsuffix .$(APP).d,$($(APP)_CSRCS) $($(APP)_CXXSRCS))))
$(foreach APP,$(notdir $(APPS)),$(eval $(APP)_COVERAGE=$(addsuffix .$(APP).gcda,$($(APP)_CSRCS) $($(APP)_CXXSRCS))))
$(foreach APP,$(notdir $(APPS)),$(eval $(APP)_COVERAGE+=$(addsuffix .$(APP).gcno,$($(APP)_CSRCS) $($(APP)_CXXSRCS))))

# Generate build rules
$(foreach APP,$(APPS),$(eval $(call app_rule,$(APP))))
$(foreach APP,$(APPS),$(foreach SRC,$($(notdir $(APP))_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(notdir $(APP)),))))
$(foreach APP,$(APPS),$(foreach SRC,$($(notdir $(APP))_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(notdir $(APP)),))))

# Include dependencies for each application object file
include $(foreach APP,$(APPS),$($(notdir $(APP))_DEPS))

CLEAN_APPS:=$(foreach APP,$(APPS),$(addprefix clean_,$(notdir $(APP))))

# Make global clean depend on $(APP) specific clean
.PHONY: $(CLEAN_APPS)
clean: $(CLEAN_APPS)

# Generate $(APP) clean rule
$(foreach APP,$(notdir $(APPS)),$(eval $(call clean_rule,$(APP))))
endif

# If there are any archives defined in the top-level Makefile, evaluate all
# required functions for each of these archives and add each clean target
# to the global CLEAN target as a dependency
ifneq ($(ARCHIVES),)
# Generate variables for $(ARCHIVE) objects and dependencies
$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(ARCHIVE)_OBJS=$(addsuffix .$(ARCHIVE).o,$($(ARCHIVE)_CSRCS) $($(ARCHIVE)_CXXSRCS))))
$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(ARCHIVE)_DEPS=$(addsuffix .$(ARCHIVE).d,$($(ARCHIVE)_CSRCS) $($(ARCHIVE)_CXXSRCS))))
$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(ARCHIVE)_COVERAGE=$(addsuffix .$(ARCHIVE).gcda,$($(ARCHIVE)_CSRCS) $($(ARCHIVE)_CXXSRCS))))
$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(ARCHIVE)_COVERAGE+=$(addsuffix .$(ARCHIVE).gcno,$($(ARCHIVE)_CSRCS) $($(ARCHIVE)_CXXSRCS))))

# Generate build rules
$(foreach ARCHIVE,$(ARCHIVES),$(eval $(call archive_rule,$(ARCHIVE))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(notdir $(ARCHIVE))_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(notdir $(ARCHIVE)),))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(notdir $(ARCHIVE))_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(notdir $(ARCHIVE)),))))

# Include dependencies for each archive object file
include $(foreach ARCHIVE,$(ARCHIVES),$($(notdir $(ARCHIVE))_DEPS))

CLEAN_ARCHIVES:=$(foreach ARCHIVE,$(ARCHIVES),$(addprefix clean_,$(notdir $(ARCHIVE))))

# Make global clean depend on $(ARCHIVE) specific clean
.PHONY: $(CLEAN_ARCHIVES)
clean: $(CLEAN_ARCHIVES)

# Generate $(ARCHIVE) clean rule
$(foreach ARCHIVE,$(notdir $(ARCHIVES)),$(eval $(call clean_rule,$(ARCHIVE))))
endif

# If there are any libraries (shared objects) defined in the top-level Makefile,
# evaluate all required functions for each of these libraries and add each clean
# target to the global CLEAN target as a dependency
ifneq ($(LIBS),)
# Generate variables for $(LIB) objects and dependencies
$(foreach LIB,$(notdir $(LIBS)),$(eval $(LIB)_OBJS=$(addsuffix .$(LIB).o,$($(LIB)_CSRCS) $($(LIB)_CXXSRCS))))
$(foreach LIB,$(notdir $(LIBS)),$(eval $(LIB)_DEPS=$(addsuffix .$(LIB).d,$($(LIB)_CSRCS) $($(LIB)_CXXSRCS))))
$(foreach LIB,$(notdir $(LIBS)),$(eval $(LIB)_COVERAGE=$(addsuffix .$(LIB).gcda,$($(LIB)_CSRCS) $($(LIB)_CXXSRCS))))
$(foreach LIB,$(notdir $(LIBS)),$(eval $(LIB)_COVERAGE+=$(addsuffix .$(LIB).gcno,$($(LIB)_CSRCS) $($(LIB)_CXXSRCS))))

# Generate build rules
$(foreach LIB,$(LIBS),$(eval $(call shared_lib_rule,$(LIB))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(notdir $(LIB))_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(notdir $(LIB)),-fPIC))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(notdir $(LIB))_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(notdir $(LIB)),-fPIC))))

# Include dependencies for each library object file
include $(foreach LIB,$(LIBS),$($(notdir $(LIB))_DEPS))

CLEAN_LIBS:=$(foreach LIB,$(LIBS),$(addprefix clean_,$(notdir $(LIB))))

# Make global clean depend on $(LIB) specific clean
.PHONY: $(CLEAN_LIBS)
clean: $(CLEAN_LIBS)

# Generate $(LIB) clean rule
$(foreach LIB,$(notdir $(LIBS)),$(eval $(call clean_rule,$(LIB))))

endif

# Make empty targets for cleaning and coverage report generation
.PHONY: clean coverage

# Build target for coverage report generation
coverage: coverage/coverage.html

# Actual command for the generation of the coverage report
coverage/coverage.html:
	mkdir -p $(dir $@)
	gcovr --html --html-details --html-theme github.dark-blue --decisions --calls --output $@

# Clean should also clean any coverage reporting
clean: clean_coverage

# Clean target for cleaning coverage reporting
clean_coverage:
	@printf "%20s: %s\n" "CLEAN" "coverage"
	$(Q)rm -rf coverage

# The dependency files are generated as a byproduct of the compilation of the
# source files. Preserve them once compilation is finished.
PRECIOUS: %.d
