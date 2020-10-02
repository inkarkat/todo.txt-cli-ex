#!/bin/bash
#

test_description='addendum action extension

This test covers adding a task to a separate add.txt
'
. ./test-lib.sh

cat > todo.txt <<EOF
existing task
EOF

> add.txt
test_todo_session 'make addendum' <<EOF
>>> todo.sh addendum offline idea
1 offline idea
ADD: 1 added.

>>> todo.sh -p list
1 existing task
--
TODO: 1 of 1 tasks shown

>>> todo.sh -p listfile add.txt
1 offline idea
--
ADD: 1 of 1 tasks shown
EOF

test_todo_session 'make another addendum' <<EOF
>>> todo.sh addendum second offline idea
2 second offline idea
ADD: 2 added.

>>> todo.sh -p listfile add.txt
1 offline idea
2 second offline idea
--
ADD: 2 of 2 tasks shown
EOF

> add.txt
test_todo_session 'addendum with tomorrow in date format renders into canonical date' <<EOF
>>> todo.sh addendum go to bed like m:14-Feb-2009
1 go to bed like m:2009-02-14
ADD: 1 added.
EOF

test_done
