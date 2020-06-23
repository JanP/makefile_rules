HELLO_A=hello.a

$(HELLO_A)_CSRCS=hello_a/src/hello_a.c
$(HELLO_A)_CXXSRCS=hello_a/src/hello_a.cpp

$(HELLO_A)_OBJS=$(addsuffix .$(HELLO_A).o,$($(HELLO_A)_CSRCS) $($(HELLO_A)_CXXSRCS))
$(HELLO_A)_DEPS=$(addsuffix .$(HELLO_A).d,$($(HELLO_A)_CSRCS) $($(HELLO_A)_CXXSRCS))

clean_$(notdir $(HELLO_A)):
	$(call pprintf,"CLEAN",$(HELLO_A))
	$(Q)rm -f $($(HELLO_A)_OBJS) $($(HELLO_A)_DEPS)
