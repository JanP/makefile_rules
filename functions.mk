# Functions used by rules.mk

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
	$(call pprintf,"LD",$1)
	$(Q)$(call ld,$1) -o $1 $($(notdir $1)_OBJS) $($(notdir $1)_LDFLAGS) $(LDFLAGS)
endef

# Function to generate a specific rule for building a shared library
define shared_lib_rule
$1: $($(notdir $1)_OBJS)
	$(call pprintf,"LD",$1)
	$(Q)$(call ld,$1) -o $1 $($(notdir $1)_OBJS) $($(notdir $1)_LDFLAGS) $(LDFLAGS) -shared
endef

# Function to generate a specific rule for building an archive
define archive_rule
$1: $($(notdir $1)_OBJS)
	$(call pprintf,"AR",$1)
	$(Q)$(call ar,$1) $(ARFLAGS) $1 $($(notdir $1)_OBJS)
endef

# Function to generate a specific rule to create each object file and the
# dependencies for regenerating the object file based on the C source
define c_obj_rule
$1.$2.o $1.$2.d: $1
	$(call pprintf,"C",$1)
	$(Q)$(call cc,$2) -c -o $1.$2.o $1 -MT $1.$2.o -MMD -MP -MF $1.$2.d $($(notdir $2)_CFLAGS) $(CFLAGS) $3
endef

# FUnction to generate a specific rule to create each object file and the
# dependencies for regenerating the object file based on the C++ source
define cxx_obj_rule
$1.$2.o $1.$2.d: $1
	$(call pprintf,"C++",$1)
	$(Q)$(call cxx,$2) -c -o $1.$2.o $1 -MT $1.$2.o -MMD -MP -MF $1.$2.d $($(notdir $2)_CXXFLAGS) $(CXXFLAGS) $3
endef

# Functio nto generate a specific rule to clean up generated objects and
# dependencies for a specified build target
define clean_rule
clean_$1:
	$(call pprintf,"CLEAN",$1)
	$(Q)rm -f $($1_OBJS) $($1_DEPS)
endef
