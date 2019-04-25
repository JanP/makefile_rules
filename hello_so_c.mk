HELLO_SO_C=hello_so_c
$(HELLO_SO_C)_CSRCS=hello_main_so.c
$(HELLO_SO_C)_CXXSRCS=
$(HELLO_SO_C)_OBJS=$(addsuffix .o,$($(HELLO_SO_C)_CSRCS) $($(HELLO_SO_C)_CXXSRCS))
$(HELLO_SO_C)_DEPS=$(addsuffix .d,$($(HELLO_SO_C)_CSRCS) $($(HELLO_SO_C)_CXXSRCS))
$(HELLO_SO_C)_CFLAGS=$(CFLAGS) -Ihello_so/inc
$(HELLO_SO_C)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_SO_C)_LDFLAGS=$(LDFLAGS) -L. -lhello -lstdc++

$(HELLO_SO_C): libhello.so
