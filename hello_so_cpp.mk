HELLO_SO_CPP=hello_so_cpp
$(HELLO_SO_CPP)_CSRCS=
$(HELLO_SO_CPP)_CXXSRCS=hello_main_so.cpp
$(HELLO_SO_CPP)_OBJS=$(addsuffix .o,$($(HELLO_SO_CPP)_CSRCS) $($(HELLO_SO_CPP)_CXXSRCS))
$(HELLO_SO_CPP)_DEPS=$(addsuffix .d,$($(HELLO_SO_CPP)_CSRCS) $($(HELLO_SO_CPP)_CXXSRCS))
$(HELLO_SO_CPP)_CFLAGS=$(CFLAGS)
$(HELLO_SO_CPP)_CXXFLAGS=$(CXXFLAGS) -Ihello_so/inc
$(HELLO_SO_CPP)_LDFLAGS=$(LDFLAGS) -L. -lhello -lstdc++

$(HELLO_SO_CPP): libhello.so
