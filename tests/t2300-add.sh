#!/bin/bash
#

test_description='add action extension

This test covers adding a task with shortcuts and special notation in markers.
'
. ./test-lib.sh

> todo.txt
test_todo_session 'add with tomorrow in date format renders into canonical date' <<EOF
>>> todo.sh add go to bed like m:14-Feb-2009
1 go to bed like m:2009-02-14
TODO: 1 added.
EOF

> todo.txt
test_todo_session 'add with today in date format renders into canonical date' <<EOF
>>> todo.sh add go to bed like m:today | sed -e "s/$(date -d today +%F)/TODAY/"
1 go to bed like m:TODAY
TODO: 1 added.
EOF

> todo.txt
test_todo_session 'add with today in date format does not render into canonical date' <<EOF
>>> todo.sh add go to bed like m:13-Feb-2009
1 go to bed like m:13-Feb-2009
TODO: 1 added.
EOF

> todo.txt
test_todo_session 'add with tomorrow in all-numbers format is not rendered' <<EOF
>>> todo.sh add go to bed like m:20090214
1 go to bed like m:20090214
TODO: 1 added.
EOF


cat > todo.txt <<EOF
2009-02-01 a simple task
2009-02-01 another simple task
EOF

test_todo_session 'add with relative task reference to a previous task is rendered as absolute task' <<EOF
>>> todo.sh add task reference to previous task a:.-2
3 task reference to previous task a:1
TODO: 3 added.
EOF

test_todo_session 'add with relative task reference to a following task is rendered as absolute task' <<EOF
>>> todo.sh add task reference to following task a:.+1
4 task reference to following task a:5
TODO: 4 added.
EOF

test_done
