HELLO_A=$(notdir hello_a/hello.a)

$(HELLO_A)_CSRCS=hello_a/src/hello_a.c
$(HELLO_A)_CXXSRCS=hello_a/src/hello_a.cpp

clean_$(HELLO_A):
	$(call pprintf,"CLEAN",$(HELLO_A))
	$(Q)rm -f $($(HELLO_A)_OBJS) $($(HELLO_A)_DEPS)
