HELLO_SO_C=hello_so_c/hello_so_c
$(HELLO_SO_C)_CSRCS=hello_so_c/src/hello_main_so.c
$(HELLO_SO_C)_CXXSRCS=
$(HELLO_SO_C)_OBJS=$(addsuffix .o,$($(HELLO_SO_C)_CSRCS) $($(HELLO_SO_C)_CXXSRCS))
$(HELLO_SO_C)_DEPS=$(addsuffix .d,$($(HELLO_SO_C)_CSRCS) $($(HELLO_SO_C)_CXXSRCS))
$(HELLO_SO_C)_CFLAGS=$(CFLAGS) -I./hello_so/inc
$(HELLO_SO_C)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_SO_C)_LDFLAGS=$(LDFLAGS) -L./hello_so -lhello -lstdc++ -Wl,-rpath=./hello_so

$(HELLO_SO_C): hello_so/libhello.so

clean_$(notdir $(HELLO_SO_C)):
	@echo "CLEAN $(HELLO_SO_C)"
	$(Q)rm -f $($(HELLO_SO_C)_OBJS) $($(HELLO_SO_C)_DEPS)