HELLO_A_C=hello_a_c

$(HELLO_A_C)_CSRCS=hello_a_c/src/hello_main_a.c

$(HELLO_A_C)_OBJS=$(addsuffix .$(HELLO_A_C).o,$($(HELLO_A_C)_CSRCS) $($(HELLO_A_C)_CXXSRCS))
$(HELLO_A_C)_DEPS=$(addsuffix .$(HELLO_A_C).d,$($(HELLO_A_C)_CSRCS) $($(HELLO_A_C)_CXXSRCS))

$(HELLO_A_C)_CFLAGS=-Ihello_a/inc
$(HELLO_A_C)_LDFLAGS=hello_a/hello.a

hello_a_c/$(HELLO_A_C): hello_a/hello.a

clean_$(notdir $(HELLO_A_C)):
	$(call pprintf,"CLEAN",$(HELLO_A_C))
	$(Q)rm -f $($(HELLO_A_C)_OBJS) $($(HELLO_A_C)_DEPS)
