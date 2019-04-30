HELLO_A_CPP=hello_a_cpp/hello_a_cpp
$(HELLO_A_CPP)_CSRCS=
$(HELLO_A_CPP)_CXXSRCS=hello_a_cpp/src/hello_main_a.cpp
$(HELLO_A_CPP)_OBJS=$(addsuffix .o,$($(HELLO_A_CPP)_CSRCS) $($(HELLO_A_CPP)_CXXSRCS))
$(HELLO_A_CPP)_DEPS=$(addsuffix .d,$($(HELLO_A_CPP)_CSRCS) $($(HELLO_A_CPP)_CXXSRCS))
$(HELLO_A_CPP)_CFLAGS=$(CFLAGS)
$(HELLO_A_CPP)_CXXFLAGS=$(CXXFLAGS) -Ihello_a/inc
$(HELLO_A_CPP)_LDFLAGS=$(LDFLAGS) hello_a/hello.a -lstdc++

$(HELLO_A_CPP): hello_a/hello.a

clean_$(notdir $(HELLO_A_CPP)):
	@echo "CLEAN $(HELLO_A_CPP)"
	$(Q)rm -f $($(HELLO_A_CPP)_OBJS) $($(HELLO_A_CPP)_DEPS)
