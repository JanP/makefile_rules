#
# rules.mk contains all the functions and evaluations for building the apps,
# libs and archives defined in the top-level Makefile.
# Each app, lib and archive has their own set of definitions and
# dependencies on what to build and how to build them based on the compiler
# flags.
# See LICENSE for usage terms.
#

# By default, make all the builds silent
Q=@
ifeq ($(V),1)
Q=
endif

# Default values for the C compiler and C compiler flags
CC=gcc
CFLAGS=-Wall -Wextra -std=c11

# Default values for the C++ compiler and the C++ compiler flags
CXX=g++
CXXFLAGS=-Wall -Wextra -Weffc++ -std=c++17

# Default value for the linker and the linker flags
LD=gcc
LDFLAGS=

# Include each set of definitions and dependencies for APPS,
# LIBS and ARCHIVES defined in the top-level Makefile
include $(foreach APP,$(APPS),$(APP).mk)
include $(foreach ARCHIVE,$(ARCHIVES),$(ARCHIVE).mk)
include $(foreach LIB,$(LIBS),$(LIB).mk)

# Function to generate a specific rule for building each application
define app_rule
$1: $($1_OBJS)
	@echo "LD: $1"
	$(Q)$(LD) -o $1 $($1_OBJS) $($1_LDFLAGS)
endef

# Function to generate a specific rule for creating each archive
define archive_rule
$1: $($1_OBJS)
	@echo "ARCHIVE: $1"
	$(Q)$(AR) -ru $1 $($1_OBJS)
endef

# Function to generate a specific rule for creating each shared object
define shared_object_rule
$1: $($1_OBJS)
	@echo "SHARED OBJECT: $1"
	$(Q)$(LD) -shared -o $1 $($1_OBJS) $($1_LDFLAGS)
endef

# Function to generate a specific rule to create each object file and the
# dependencies for regenerating said object file based on the C source
define c_obj_rule
$1.o: $1 $1.d
	@echo "C: $1"
	$(Q)$(CC) -c -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

# Function to generate a specific rule to create each object file and the
# dependencies for regenerating said object file based on the C++ source
define cxx_obj_rule
$1.o: $1 $1.d
	@echo "C++: $1"
	$(Q)$(CXX) -c -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CXXFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

# Dedicated function for objects for the shared object as these require
# -fPIC compiler flag
define c_lib_obj_rule
$1.o: $1 $1.d
	@echo "C: $1"
	$(Q)$(CC) -c -fPIC -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

# Dedicated function for objects for the shared object as these require
# -fPIC compiler flag
define cxx_lib_obj_rule
$1.o: $1 $1.d
	@echo "C++: $1"
	$(Q)$(CXX) -c -fPIC -o $1.o $1 -MT $1.o -MMD -MP -MF $1.Td $($2_CXXFLAGS)
	@mv $1.Td $1.d && touch $1.o
endef

clean:
	@echo "CLEAN"
	$(Q)rm -rf *.d *.Td *.o $(APPS) $(ARCHIVES) $(LIBS)

# If there are any applications defined in the top-level Makefile, evaluate all
# required functions for each of these applications and add each clean
# target to the global CLEAN target as a dependency
ifneq ($(APPS),)
$(foreach APP,$(APPS),$(eval $(call app_rule,$(APP))))
$(foreach APP,$(APPS),$(foreach SRC,$($(APP)_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(APP)))))
$(foreach APP,$(APPS),$(foreach SRC,$($(APP)_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(APP)))))
# Include dependencies for each application object file
-include $(foreach APP,$(APPS),$($(APP)_DEPS))
clean: $(foreach APP,$(APPS),$(addprefix clean_,$(notdir $(APP))))

endif

# If there are any archives defined in the top-level Makefile, evaluate all
# required functions for each of these archives and add each clean target
# to the global CLEAN target as a dependency
ifneq ($(ARCHIVES),)
$(foreach ARCHIVE,$(ARCHIVES),$(eval $(call archive_rule,$(ARCHIVE))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(ARCHIVE)_CSRCS),$(eval $(call c_obj_rule,$(SRC),$(ARCHIVE)))))
$(foreach ARCHIVE,$(ARCHIVES),$(foreach SRC,$($(ARCHIVE)_CXXSRCS),$(eval $(call cxx_obj_rule,$(SRC),$(ARCHIVE)))))
# Include dependencies for each archive object file
-include $(foreach ARCHIVE,$(ARCHIVES),$($(ARCHIVE)_DEPS))
clean: $(foreach ARCHIVE,$(ARCHIVES),$(addprefix clean_,$(notdir $(ARCHIVE))))

endif

# If there are any libraries (shared objects) defined in the top-level Makefile,
# evaluate all required functions for each of these libraries and add each clean
# target to the global CLEAN target as a dependency
ifneq ($(LIBS),)
$(foreach LIB,$(LIBS),$(eval $(call shared_object_rule,$(LIB))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(LIB)_CSRCS),$(eval $(call c_lib_obj_rule,$(SRC),$(LIB)))))
$(foreach LIB,$(LIBS),$(foreach SRC,$($(LIB)_CXXSRCS),$(eval $(call cxx_lib_obj_rule,$(SRC),$(LIB)))))
# Include dependencies for each library object file
-include $(foreach LIB,$(LIBS),$($(LIB)_DEPS))
clean: $(foreach LIB,$(LIBS),$(addprefix clean_,$(notdir $(LIB))))

endif

# The dpendency files are generated as a byproduct of the compilation of the
# source files. These don't depend on anything and preserve them once
# compilation is finished.
%.d: ;
PRECIOUS: %.d
