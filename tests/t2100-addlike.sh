#!/bin/bash
#

test_description='addlike action

This test covers adding of a task with projects and contents taken from another task.
'
. ./test-lib.sh

> todo.txt
test_todo_session 'addlike plain' <<EOF
>>> todo.sh add notice the daisies
1 notice the daisies
TODO: 1 added.

>>> todo.sh addlike 1 smell the roses
2 smell the roses
TODO: 2 added.

>>> todo.sh -p list
1 notice the daisies
2 smell the roses
--
TODO: 2 of 2 tasks shown
EOF

> todo.txt
test_todo_session 'addlike plain omit ITEM#' <<EOF
>>> todo.sh add notice the daisies
1 notice the daisies
TODO: 1 added.

>>> todo.sh addlike smell the fish
2 smell the fish
TODO: 2 added.
EOF


> todo.txt
test_todo_session 'addlike project' <<EOF
>>> todo.sh add +flowers notice the daisies
1 +flowers notice the daisies
TODO: 1 added.

>>> todo.sh addlike 1 smell the roses
2 +flowers smell the roses
TODO: 2 added.

>>> todo.sh -p list
1 +flowers notice the daisies
2 +flowers smell the roses
--
TODO: 2 of 2 tasks shown
EOF

> todo.txt
test_todo_session 'addlike project and context at beginning' <<EOF
>>> todo.sh add +flowers @outside notice the daisies
1 +flowers @outside notice the daisies
TODO: 1 added.

>>> todo.sh addlike 1 smell the roses
2 +flowers @outside smell the roses
TODO: 2 added.

>>> todo.sh -p list
1 +flowers @outside notice the daisies
2 +flowers @outside smell the roses
--
TODO: 2 of 2 tasks shown
EOF

> todo.txt
test_todo_session 'addlike project and context in middle' <<EOF
>>> todo.sh add notice +flowers the @outside daisies
1 notice +flowers the @outside daisies
TODO: 1 added.

>>> todo.sh addlike 1 smell the roses
2 +flowers @outside smell the roses
TODO: 2 added.

>>> todo.sh -p list
2 +flowers @outside smell the roses
1 notice +flowers the @outside daisies
--
TODO: 2 of 2 tasks shown
EOF

> todo.txt
test_todo_session 'addlike project and context at end' <<EOF
>>> todo.sh add notice the daisies +flowers @outside
1 notice the daisies +flowers @outside
TODO: 1 added.

>>> todo.sh addlike 1 smell the roses
2 smell the roses +flowers @outside
TODO: 2 added.

>>> todo.sh -p list
1 notice the daisies +flowers @outside
2 smell the roses +flowers @outside
--
TODO: 2 of 2 tasks shown
EOF

> todo.txt
test_todo_session 'addlike omit ITEM#' <<EOF
>>> todo.sh add +tv @home watch movies
1 +tv @home watch movies
TODO: 1 added.

>>> todo.sh add +flowers @outside notice the daisies
2 +flowers @outside notice the daisies
TODO: 2 added.

>>> todo.sh addlike smell the fish
3 +flowers @outside smell the fish
TODO: 3 added.
EOF

> todo.txt
test_todo_session 'addlike ignore similar stuff' <<EOF
>>> todo.sh add notice tom+jerry at friends@example.com for now
1 notice tom+jerry at friends@example.com for now
TODO: 1 added.

>>> todo.sh addlike 1 an ordinary task
2 an ordinary task
TODO: 2 added.

>>> todo.sh -p list
2 an ordinary task
1 notice tom+jerry at friends@example.com for now
--
TODO: 2 of 2 tasks shown
EOF

test_done
