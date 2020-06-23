HELLO_C=hello_c

$(HELLO_C)_CSRCS=hello_c/src/hello.c

$(HELLO_C)_OBJS=$(addsuffix .$(HELLO_C).o,$($(HELLO_C)_CSRCS) $($(HELLO_C)_CXXSRCS))
$(HELLO_C)_DEPS=$(addsuffix .$(HELLO_C).d,$($(HELLO_C)_CSRCS) $($(HELLO_C)_CXXSRCS))

clean_$(HELLO_C):
	$(call pprintf,"CLEAN",$(HELLO_C))
	$(Q)rm -f $($(HELLO_C)_OBJS) $($(HELLO_C)_DEPS)
