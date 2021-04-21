HELLO_A_CPP=$(notdir hello_a_cpp/hello_a_cpp)

$(HELLO_A_CPP)_CXXSRCS=hello_a_cpp/src/hello_main_a.cpp

$(HELLO_A_CPP)_CXXFLAGS=-Ihello_a/inc
$(HELLO_A_CPP)_LDFLAGS=hello_a/hello.a -lstdc++

hello_a_cpp/hello_a_cpp: hello_a/hello.a
