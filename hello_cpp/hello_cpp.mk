HELLO_CPP=hello_cpp/hello_cpp
$(HELLO_CPP)_CSRCS=
$(HELLO_CPP)_CXXSRCS=hello_cpp/src/hello.cpp
$(HELLO_CPP)_OBJS=$(addsuffix .o,$($(HELLO_CPP)_CSRCS) $($(HELLO_CPP)_CXXSRCS))
$(HELLO_CPP)_DEPS=$(addsuffix .d,$($(HELLO_CPP)_CSRCS) $($(HELLO_CPP)_CXXSRCS))
$(HELLO_CPP)_CFLAGS=$(CFLAGS)
$(HELLO_CPP)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_CPP)_LDFLAGS=$(LDFLAGS) -lstdc++

clean_$(notdir $(HELLO_CPP)):
	@echo "CLEAN $(HELLO_CPP)"
	$(Q)rm -f $($(HELLO_CPP)_OBJS) $($(HELLO_CPP)_DEPS)
