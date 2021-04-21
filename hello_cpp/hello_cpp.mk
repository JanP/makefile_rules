HELLO_CPP=$(notdir hello_cpp/hello_cpp)

$(HELLO_CPP)_CXXSRCS=hello_cpp/src/hello.cpp

$(HELLO_CPP)_LDFLAGS=-lstdc++
