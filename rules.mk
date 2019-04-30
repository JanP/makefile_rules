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

clean: clean_hello_c clean_hello_cpp clean_hello_a_c

clean:
	@echo "CLEAN"
	$(Q)rm -rf *.d *.Td *.o $(APPS) $(ARCHIVES) $(LIBS)
