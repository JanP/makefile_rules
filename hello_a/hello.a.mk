HELLO_A=hello_a/hello.a
$(HELLO_A)_CSRCS=hello_a/src/hello_a.c
$(HELLO_A)_CXXSRCS=hello_a/src/hello_a.cpp
$(HELLO_A)_OBJS=$(addsuffix .o,$($(HELLO_A)_CSRCS) $($(HELLO_A)_CXXSRCS))
$(HELLO_A)_DEPS=$(addsuffix .d,$($(HELLO_A)_CSRCS) $($(HELLO_A)_CXXSRCS))
$(HELLO_A)_CFLAGS=$(CFLAGS)
$(HELLO_A)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_A)_LDFLAGS=$(LDFLAGS)

clean_$(notdir $(HELLO_A)):
	@echo "CLEAN $(HELLO_A)"
	$(Q)rm -f $($(HELLO_A)_OBJS) $($(HELLO_A)_DEPS) $(HELLO_A)
