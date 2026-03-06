.PHONY: generate clean lint

generate:
	@if command -v buf >/dev/null 2>&1; then \
		echo "Generating with buf..."; \
		buf generate; \
	else \
		echo "buf not found. Install: brew install bufbuild/buf/buf"; \
		exit 1; \
	fi

lint:
	buf lint

clean:
	rm -rf gen/
