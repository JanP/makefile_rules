HELLO_C=hello_c/hello_c
$(HELLO_C)_CSRCS=hello_c/src/hello.c
$(HELLO_C)_CXXSRCS=
$(HELLO_C)_OBJS=$(addsuffix .o,$($(HELLO_C)_CSRCS) $($(HELLO_C)_CXXSRCS))
$(HELLO_C)_DEPS=$(addsuffix .d,$($(HELLO_C)_CSRCS) $($(HELLO_C)_CXXSRCS))
$(HELLO_C)_CFLAGS=$(CFLAGS)
$(HELLO_C)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_C)_LDFLAGS=$(LDFLAGS)

clean_$(notdir $(HELLO_C)):
	@echo "CLEAN $(HELLO_C)"
	$(Q)rm -f $($(HELLO_C)_OBJS) $($(HELLO_C)_DEPS)
