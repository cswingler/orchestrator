VERSION=3.0.11-1

build: copy_build run_buildscript export_artifacts

copy_build:
	mkdir -p $$GOPATH/src/github.com/github/
	cp -R /orchestrator $$GOPATH/src/github.com/github/

run_buildscript:
	cd $$GOPATH/src/github.com/github/orchestrator; bash build.sh -t linux

export_artifacts:
	cp -R /tmp/orchestrator-release/ /orchestrator/artifacts/
