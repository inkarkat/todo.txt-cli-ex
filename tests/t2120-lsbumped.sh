#!/usr/bin/env bash
#

test_description='lsbumped action

This test covers listing bumped tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-11-11 buy beer
EOF
test_todo_session 'lsbumped no bumps' <<EOF
>>> todo.sh -p lsbumped
--
TODO: 0 bumped of 1 tasks shown
EOF


cat > todo.txt <<EOF
2011-08-08 mow the lawn !:3 and cut the trees @outside
2011-09-09 walk the dog !:1 @outside
2011-09-09 watch tv !:1
2011-10-10 clean the bike !:11
2011-11-11 buy beer
EOF

test_todo_session 'lsbumped' <<EOF
>>> todo.sh -p lsbumped
4 2011-10-10 clean the bike !:11
1 2011-08-08 mow the lawn !:3 and cut the trees @outside
3 2011-09-09 watch tv !:1
2 2011-09-09 walk the dog !:1 @outside
--
TODO: 4 bumped of 5 tasks shown
EOF

test_todo_session 'lsbumped TERM' <<EOF
>>> todo.sh -p lsbumped @outside
1 2011-08-08 mow the lawn !:3 and cut the trees @outside
2 2011-09-09 walk the dog !:1 @outside
--
TODO: 2 bumped of 5 tasks shown
EOF

cat > todo.txt <<EOF
2011-08-08 mow the lawn !:3 and cut the trees @outside
x 2012-01-01 2011-09-09 walk the dog !:1 @outside
2011-09-09 watch tv !:1
X 2012-01-01 2011-10-10 clean the bike !:11
2011-11-11 buy beer
EOF

test_todo_session 'lsbumped done and trashed' <<EOF
>>> todo.sh -p lsbumped
1 2011-08-08 mow the lawn !:3 and cut the trees @outside
3 2011-09-09 watch tv !:1
--
TODO: 2 bumped of 5 tasks shown
EOF

test_done
