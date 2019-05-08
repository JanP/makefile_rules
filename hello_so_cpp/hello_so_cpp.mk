HELLO_SO_CPP=hello_so_cpp
$(HELLO_SO_CPP)_CSRCS=
$(HELLO_SO_CPP)_CXXSRCS=hello_so_cpp/src/hello_main_so.cpp
$(HELLO_SO_CPP)_OBJS=$(addsuffix .$(HELLO_SO_CPP).o,$($(HELLO_SO_CPP)_CSRCS) $($(HELLO_SO_CPP)_CXXSRCS))
$(HELLO_SO_CPP)_DEPS=$(addsuffix .$(HELLO_SO_CPP).d,$($(HELLO_SO_CPP)_CSRCS) $($(HELLO_SO_CPP)_CXXSRCS))
$(HELLO_SO_CPP)_CFLAGS=$(CFLAGS)
$(HELLO_SO_CPP)_CXXFLAGS=$(CXXFLAGS) -I./hello_so/inc
$(HELLO_SO_CPP)_LDFLAGS=$(LDFLAGS) -L./hello_so -lhello -lstdc++ -Wl,-rpath=./hello_so

hello_so_cpp/$(HELLO_SO_CPP): hello_so/libhello.so

clean_$(notdir $(HELLO_SO_CPP)):
	@echo "CLEAN $(HELLO_SO_CPP)"
	$(Q)rm -f $($(HELLO_SO_CPP)_OBJS) $($(HELLO_SO_CPP)_DEPS)
