# Variables
DEFAULT_PROTOC ?= protoc
PROTOC         ?= $(DEFAULT_PROTOC)
OUTDIR_PREFIX  ?= ./.codegen
OUTDIR         ?=
INCLUDE        ?= .:/usr/local/include
FLAGS          ?=

# finds all proto files to code gen
DEPS := $(shell find . -type f -name '*.proto')

.PHONY: $(DEPS)

# genrates gocode from proto files
gen-go:
	@echo Building Go Codegen
	$(eval OUTDIR := $(OUTDIR_PREFIX)/go)
	$(eval FLAGS += --go_out=plugins=grpc:$(OUTDIR))
go: gen-go | $(DEPS)
	@echo Completed Go Codegen

# generates python code from proto files
gen-py27:
	@echo Building Python 2.7 Codegen
	$(eval PROTOC := python -m grpc.tools.protoc)
	$(eval OUTDIR := $(OUTDIR_PREFIX)/py27)
	$(eval FLAGS += --python_out=$(OUTDIR))
	$(eval FLAGS += --grpc_python_out=$(OUTDIR))
py27: gen-py27 | $(DEPS)
	@echo Completed Python 2.7 Codegen

$(DEPS): %.proto:
	@echo Generating $*.proto
	@ mkdir -p $(OUTDIR)
	$(eval --proto_path=.:$(INCLUDE))
	$(PROTOC) -I $(INCLUDE) $(FLAGS) $*.proto

docker: docker-go docker-py27

docker-go:
	docker build \
		--force-rm \
		-f protoc.go.Dockerfile \
		-t soon/protoc.go:latest .

docker-py27:
	docker build \
		--force-rm \
		-f protoc.py27.Dockerfile \
		-t soon/protoc.py27:latest .
