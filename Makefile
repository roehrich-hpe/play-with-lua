OUTPUT_HANDLER = --output tools/TAP.lua

TAG ?=  # specify a string like TAG="-t mytag"

.PHONY: tests-1
tests-1:
	busted $(TAG) $(OUTPUT_HANDLER) tests-1/*.lua

.PHONY: tests-2
tests-2:
	busted $(TAG) $(OUTPUT_HANDLER) tests-2/*.lua


