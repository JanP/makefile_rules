HELLO_SO=$(notdir hello_so/libhello.so)

$(HELLO_SO)_CSRCS=hello_so/src/hello_so.c
$(HELLO_SO)_CXXSRCS=hello_so/src/hello_so.cpp

clean_$(HELLO_SO):
	$(call pprintf,"CLEAN",$(HELLO_SO))
	$(Q)rm -f $($(HELLO_SO)_OBJS) $($(HELLO_SO)_DEPS)
