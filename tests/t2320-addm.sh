#!/usr/bin/env bash
#

test_description='addm action extension

This test covers adding tasks (one per line).
'
. ./test-lib.sh

: > todo.txt
test_todo_session 'addm adds individual passed lines as individual tasks' <<EOF
>>> todo.sh addm $'pick some flowers\ncut some wood\nrelax in the forest'
1 pick some flowers
TODO: 1 added.
2 cut some wood
TODO: 2 added.
3 relax in the forest
TODO: 3 added.
EOF

: > todo.txt
test_todo_session 'addm adds individual passed lines (but not separate args) as individual tasks' <<EOF
>>> todo.sh addm 'pick some' $'flowers\ncut' $'some wood\nrelax' in the forest
1 pick some flowers
TODO: 1 added.
2 cut some wood
TODO: 2 added.
3 relax in the forest
TODO: 3 added.
EOF

: > todo.txt
test_todo_session 'addm adds individual passed lines as individual tasks with custom prefix' <<EOF
>>> todo.sh addm -b +gardening $'pick some flowers\ncut some wood\nrelax in the forest'
1 +gardening pick some flowers
TODO: 1 added.
2 +gardening cut some wood
TODO: 2 added.
3 +gardening relax in the forest
TODO: 3 added.
EOF

: > todo.txt
test_todo_session 'addm adds individual passed lines as individual tasks with custom suffix' <<EOF
>>> todo.sh addm -e @outside $'pick some flowers\ncut some wood\nrelax in the forest'
1 pick some flowers @outside
TODO: 1 added.
2 cut some wood @outside
TODO: 2 added.
3 relax in the forest @outside
TODO: 3 added.
EOF

: > todo.txt
test_todo_session 'addm adds individual passed lines as individual tasks with custom prefixes and suffixes' <<EOF
>>> todo.sh addm -b +gardening -e @outside $'pick some flowers\ncut some wood\nrelax in the forest'
1 +gardening pick some flowers @outside
TODO: 1 added.
2 +gardening cut some wood @outside
TODO: 2 added.
3 +gardening relax in the forest @outside
TODO: 3 added.
EOF

test_done
