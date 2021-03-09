HELLO_SO_CPP=$(notdir hello_so_cpp/hello_so_cpp)

$(HELLO_SO_CPP)_CXXSRCS=hello_so_cpp/src/hello_main_so.cpp

$(HELLO_SO_CPP)_CXXFLAGS=-I./hello_so/inc
$(HELLO_SO_CPP)_LDFLAGS=-L./hello_so -lhello -lstdc++ -Wl,-rpath=./hello_so

hello_so_cpp/hello_so_cpp: hello_so/libhello.so

clean_$(HELLO_SO_CPP):
	$(call pprintf,"CLEAN",$(HELLO_SO_CPP))
	$(Q)rm -f $($(HELLO_SO_CPP)_OBJS) $($(HELLO_SO_CPP)_DEPS)
