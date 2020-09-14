TESTS = $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh)
#TEST_OPTIONS=--verbose

# Use the main todo.sh executable and the test library and utilities from a
# ../todo.txt-cli working copy next to this.
test-copy-deps: todo.sh tests/test-lib.sh tests/aggregate-results.sh

todo.sh: ../todo.txt-cli/todo.sh
	cp $< .

tests/test-lib.sh: ../todo.txt-cli/tests/test-lib.sh
	cp $< tests/

tests/aggregate-results.sh: ../todo.txt-cli/tests/aggregate-results.sh
	cp $< tests/

test-pre-clean:
	rm -rf tests/test-results "tests/trash directory"*

aggregate-results: $(TESTS)

$(TESTS): test-pre-clean test-copy-deps
	-cd ./tests && ./$(notdir $@) $(TEST_OPTIONS)

test: aggregate-results
	tests/aggregate-results.sh tests/test-results/t*-*
	rm -rf tests/test-results

ci:
	cd ./tests && onchange-singleton-invocation --event create --event change --exec ./{} -i \; t[0-9][0-9][0-9][0-9]-*.sh

# Force tests to get run every time
.PHONY: test aggregate-results $(TESTS)
