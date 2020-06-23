HELLO_CPP=hello_cpp

$(HELLO_CPP)_CXXSRCS=hello_cpp/src/hello.cpp

$(HELLO_CPP)_OBJS=$(addsuffix .$(HELLO_CPP).o,$($(HELLO_CPP)_CSRCS) $($(HELLO_CPP)_CXXSRCS))
$(HELLO_CPP)_DEPS=$(addsuffix .$(HELLO_CPP).d,$($(HELLO_CPP)_CSRCS) $($(HELLO_CPP)_CXXSRCS))

$(HELLO_CPP)_LDFLAGS=-lstdc++

clean_$(notdir $(HELLO_CPP)):
	$(call pprintf,"CLEAN",$(HELLO_CPP))
	$(Q)rm -f $($(HELLO_CPP)_OBJS) $($(HELLO_CPP)_DEPS)
