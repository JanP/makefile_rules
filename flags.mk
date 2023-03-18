WARNINGS:=-Wall -Wextra -Wduplicated-cond -Wduplicated-branches -Wlogical-op
WARNINGS+=-Wnull-dereference -Wdouble-promotion -Wshadow
WARNINGS+=-Wformat=2 -Wformat-overflow=2

C_WARNINGS+=$(WARNINGS) -Wstrict-prototypes -Wjump-misses-init -std=c17
CXX_WARNINGS+=$(WARNINGS) -Wold-style-cast -Wuseless-cast -std=c++17

CFLAGS:=$(C_WARNINGS) -fdata-sections -ffunction-sections -fno-omit-frame-pointer $(ADDITIONAL_DEFAULT_CFLAGS)
CXXFLAGS:=$(CXX_WARNINGS) -fdata-sections -ffunction-sections -fno-omit-frame-pointer $(ADDITIONAL_DEFAULT_CXXFLAGS)
LDFLAGS:=$(ADDITIONAL_DEFAULT_LDFLAGS)

DEBUG_CFLAGS+=-g3 -Og
DEBUG_CXXFLAGS+=-g3 -Og
DEBUG_LDFLAGS+=

RELEASE_CFLAGS+=-Os -flto -ffat-lto-objects
RELEASE_CXXFLAGS+=-Os -flto -ffat-lto-objects
RELEASE_LDFLAGS+=-flto -ffat-lto-objects
