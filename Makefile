.PHONY: build-docker
build-docker:
	@docker build -t olik/ace-stream .

.PHONY: run-docker
run-docker:
	@docker run --rm -p 6878:6878 olik/ace-stream


