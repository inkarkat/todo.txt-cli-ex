#!/usr/bin/env bash
#

test_description='bump action

This test covers bumping of tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-08-08 mow the lawn
2011-09-09 watch tv
2011-10-10 clean the bike
EOF

test_todo_session 'bump without arguments' <<EOF
>>> todo.sh -p bump
usage: todo.sh bump NR [NR ...]]
=== 1
EOF

test_todo_session 'bump single NR' <<EOF
>>> todo.sh -p bump 1
1 2011-08-08 mow the lawn !:1
TODO: 1 was bumped for the first time.

>>> todo.sh -p bump 3
3 2011-10-10 clean the bike !:1
TODO: 3 was bumped for the first time.

>>> todo.sh -p append 1 "and cut the trees"
1 2011-08-08 mow the lawn !:1 and cut the trees

>>> todo.sh -p bump 1
1 2011-08-08 mow the lawn !:2 and cut the trees
TODO: 1 has now been bumped 2 times.
EOF
test_todo_session 'bump multiple NR' <<EOF
>>> todo.sh -p bump 1 2,3
1 2011-08-08 mow the lawn !:3 and cut the trees
TODO: 1 has now been bumped 3 times.
2 2011-09-09 watch tv !:1
TODO: 2 was bumped for the first time.
3 2011-10-10 clean the bike !:2
TODO: 3 has now been bumped 2 times.
EOF

test_done
