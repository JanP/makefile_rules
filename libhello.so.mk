HELLO_SO=libhello.so
$(HELLO_SO)_CSRCS=hello_so/src/hello_so.c
$(HELLO_SO)_CXXSRCS=hello_so/src/hello_so.cpp
$(HELLO_SO)_OBJS=$(addsuffix .o,$($(HELLO_SO)_CSRCS) $($(HELLO_SO)_CXXSRCS))
$(HELLO_SO)_DEPS=$(addsuffix .d,$($(HELLO_SO)_CSRCS) $($(HELLO_SO)_CXXSRCS))
$(HELLO_SO)_CFLAGS=$(CFLAGS)
$(HELLO_SO)_CXXFLAGS=$(CXXFLAGS)
$(HELLO_SO)_LDFLAGS=$(LDFLAGS)

clean_$(HELLO_SO):
	@echo "CLEAN $(HELLO_SO)"
	$(Q)rm -f $($(HELLO_SO)_OBJS) $($(HELLO_SO)_DEPS) $(HELLO_SO)
