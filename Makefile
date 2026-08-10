TESTS = $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh)
#TEST_OPTIONS=--verbose

# Use the main todo.sh executable and the test library and utilities from a
# ../todo.txt-cli working copy next to this.
DEPENDENCY_DIR ?= ../todo.txt-cli

test-copy-deps: todo.sh tests/test-lib.sh tests/aggregate-results.sh

todo.sh: $(DEPENDENCY_DIR)/todo.sh
	cp $< .

tests/test-lib.sh: $(DEPENDENCY_DIR)/tests/test-lib.sh
	cp $< tests/

tests/aggregate-results.sh: $(DEPENDENCY_DIR)/tests/aggregate-results.sh
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
	. ./.lbashcrc enter && singleton --id todo.txt-cli-ex-ci -- make-onchange TEST_OPTIONS=-i

restart-ci:
	. ./.lbashcrc enter && singleton --restart --id todo.txt-cli-ex-ci -- make-onchange TEST_OPTIONS=-i

stop-ci:
	singleton --kill --id todo.txt-cli-ex-ci

# Force tests to get run every time
.PHONY: test aggregate-results $(TESTS)
