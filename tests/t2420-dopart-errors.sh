#!/bin/bash
#

test_description='dopart action

This test covers invocation errors.
'
. ./test-lib.sh

cat > todo.txt <<EOF
remember the milk
+housing (find a building site => 2009-02-14), (obtain a bank loan, buy the site => 2009-02-13), hire an architect, build your dream home
+buy something simple
EOF

test_todo_session 'no NR' <<EOF
>>> todo.sh dopart foo
=== 1
usage: todo.sh dopart NR PART|PATTERN [COMMENT]
EOF

test_todo_session 'only one part' <<EOF
>>> todo.sh dopart 1 2
=== 1
TODO: No part 2; available parts:
1 remember the milk
EOF

test_todo_session 'no such task' <<EOF
>>> todo.sh dopart 9
=== 1
TODO: No task 9.
EOF

test_todo_session 'part already done' <<EOF
>>> todo.sh dopart 2 1
=== 1
TODO: That part is already done: (find a building site => 2009-02-14)
EOF

test_todo_session 'parts already done' <<EOF
>>> todo.sh dopart 2 2 3
=== 1
TODO: These parts are already done: (obtain a bank loan buy the site => 2009-02-13)
EOF

test_done
