HELLO_CPP=$(notdir hello_cpp/hello_cpp)

$(HELLO_CPP)_CXXSRCS=hello_cpp/src/hello.cpp

$(HELLO_CPP)_LDFLAGS=-lstdc++

clean_$(HELLO_CPP):
	$(call pprintf,"CLEAN",$(HELLO_CPP))
	$(Q)rm -f $($(HELLO_CPP)_OBJS) $($(HELLO_CPP)_DEPS)
