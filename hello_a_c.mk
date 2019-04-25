HELLO_A_C=hello_a_c
$(HELLO_A_C)_CSRCS=hello_main_a.c
$(HELLO_A_C)_CXXSRCS=
$(HELLO_A_C)_OBJS=$(addsuffix .o,$($(HELLO_A_C)_CSRCS) $($(HELLO_A_C)_CXXSRCS))
$(HELLO_A_C)_DEPS=$(addsuffix .d,$($(HELLO_A_C)_CSRCS) $($(HELLO_A_C)_CXXSRCS))
$(HELLO_A_C)_CFLAGS=$(CFLAGS) -Ihello_a/inc
$(HELLO_A_C)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_A_C)_LDFLAGS=$(LDFLAGS) hello.a

$(HELLO_A_C): hello.a
