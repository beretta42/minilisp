include config.mk

PLATFORM = 6809
CC = m6809-unknown-gcc
# These are wrappers for lwasm and lwar
ASM = m6809-unknown-as
AR = m6809-unknown-ar
LINKER = lwlink
CFLAGS = -I$(FUZIX_DIR)/Library/include -I$(FUZIX_DIR)/Library/include/6809	
COPT = -Os
LINKER_OPT = --format=raw -L$(FUZIX_DIR)/Library/libs -lc6809
LIBGCCDIR = $(dir $(shell $(CC) -print-libgcc-file-name))
LINKER_OPT += -L$(LIBGCCDIR) -lgcc
LINKER_OPT += --script=$(FUZIX_DIR)/Applications/util/$(TARGET).link
ASM_OPT = -o
CRT0 = $(FUZIX_DIR)/Library/libs/crt0_6809.o

SRCS = minilisp.c

OBJS = minilisp.o

.SUFFIXES: .c .o

all: minilisp

.c.o:
	$(CC) $(CFLAGS) $(CCOPTS) -c $<

minilisp:  $(OBJS) $(CRT0)
	$(LINKER) -mminilisp.map -o $@ $(LINKER_OPT) $^

clean:
	rm -f *~ minilisp *.o *.map
