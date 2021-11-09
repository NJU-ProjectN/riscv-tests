.PHONY: all run clean $(ALL)

ARCH ?= riscv32-npc
INST_SET ?= rv32ui
RV_DIR = isa/$(INST_SET)


ALL = $(basename $(notdir $(shell find $(RV_DIR)/. -name "*.S" | grep -v fence_i.S)))

all: $(addprefix Makefile-, $(ALL))
	@echo "" $(ALL)

$(ALL): %: Makefile-%


Makefile-%: $(RV_DIR)/%.S
	@/bin/echo -e "NAME = $*\nSRCS = $<\nLIBS += klib\nINC_PATH += $(shell pwd)/env/p $(shell pwd)/isa/macros/scalar\ninclude $${AM_HOME}/Makefile" > $@
	-@make -s -f $@ ARCH=$(ARCH) $(MAKECMDGOALS)
	-@rm -f Makefile-$*

run: all

clean:
	rm -rf Makefile-* build/
