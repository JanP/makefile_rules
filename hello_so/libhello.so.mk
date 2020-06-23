HELLO_SO=libhello.so

$(HELLO_SO)_CSRCS=hello_so/src/hello_so.c
$(HELLO_SO)_CXXSRCS=hello_so/src/hello_so.cpp

$(HELLO_SO)_OBJS=$(addsuffix .$(HELLO_SO).o,$($(HELLO_SO)_CSRCS) $($(HELLO_SO)_CXXSRCS))
$(HELLO_SO)_DEPS=$(addsuffix .$(HELLO_SO).d,$($(HELLO_SO)_CSRCS) $($(HELLO_SO)_CXXSRCS))

clean_$(notdir $(HELLO_SO)):
	$(call pprintf,"CLEAN",$(HELLO_SO))
	$(Q)rm -f $($(HELLO_SO)_OBJS) $($(HELLO_SO)_DEPS)
