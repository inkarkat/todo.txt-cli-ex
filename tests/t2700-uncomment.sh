#!/usr/bin/env bash
#

test_description='uncomment action

This test covers uncommenting.
'
. ./test-lib.sh

cat > todo.txt <<EOF
X 2011-08-10 2011-08-08 mow the lawn => too tired
x 2011-08-10 2011-08-08 buy groceries
EOF
test_todo_session 'uncomment removes the comment or complains' <<EOF
>>> todo.sh -p -x lstrashable
1 X 2011-08-10 2011-08-08 mow the lawn => too tired
--
TODO: 1 of 2 tasks shown

>>> todo.sh -x uncomment 1
1 X 2011-08-10 2011-08-08 mow the lawn => too tired
TODO: Replaced task with:
1 X 2011-08-10 2011-08-08 mow the lawn

>>> todo.sh -p -x lsdo
2 x 2011-08-10 2011-08-08 buy groceries
--
TODO: 1 of 2 tasks shown

>>> todo.sh -x uncomment 2
2 x 2011-08-10 2011-08-08 buy groceries
TODO: Task 2 does not contain a comment.
=== 1
EOF

cat > todo.txt <<EOF
X 2011-08-10 2011-08-08 nobody commented text => 
x 2011-08-10 2011-08-08 buy groceries
EOF
test_todo_session 'uncomment -q does not complain if no comment' <<'EOF'
>>> todo.sh -p -x lsdo
2 x 2011-08-10 2011-08-08 buy groceries
--
TODO: 1 of 2 tasks shown

>>> todo.sh -x uncomment -q 2

>>> todo.sh -x uncomment -q 2 irrelevant new comment
EOF
test_todo_session 'uncomment -q confirms removal of empty comment' <<'EOF'
>>> todo.sh -p -x lstrashable
1 X 2011-08-10 2011-08-08 nobody commented text => 
--
TODO: 1 of 2 tasks shown

>>> printf y | todo.sh -x uncomment -q 1
\
1 X 2011-08-10 2011-08-08 nobody commented text => 
TODO: Replaced task with:
1 X 2011-08-10 2011-08-08 nobody commented text
EOF

cat > todo.txt <<EOF
x 2011-08-10 2011-08-08 mow the lawn => too tired
x 2011-08-10 2011-08-08 pick some flowers => sunny day
x 2011-08-10 2011-08-08 wash the car => very dirty
EOF
test_todo_session 'uncomment -q queries what to do (unless forced)' <<'EOF'
>>> todo.sh -p -x lsdo
1 x 2011-08-10 2011-08-08 mow the lawn => too tired
2 x 2011-08-10 2011-08-08 pick some flowers => sunny day
3 x 2011-08-10 2011-08-08 wash the car => very dirty
--
TODO: 3 of 3 tasks shown

>>> printf y | todo.sh -x uncomment -q 1
\
1 x 2011-08-10 2011-08-08 mow the lawn => too tired
TODO: Replaced task with:
1 x 2011-08-10 2011-08-08 mow the lawn

>>> printf n | todo.sh -x uncomment -q 2
\
=== 4

>>> printf d | todo.sh -x uncomment -q 3
\
3 x 2011-08-10 2011-08-08 wash the car => very dirty
TODO: Replaced task with:
3 x 2011-08-10 2011-08-08 wash the car; very dirty

>>> todo.sh -x -f uncomment -q 2
2 x 2011-08-10 2011-08-08 pick some flowers => sunny day
TODO: Replaced task with:
2 x 2011-08-10 2011-08-08 pick some flowers
EOF

cat > todo.txt <<EOF
X 2011-08-10 2011-08-08 mow the lawn => too tired
EOF
test_todo_session 'uncomment replaces the comment' <<EOF
>>> todo.sh -p -x lstrashable
1 X 2011-08-10 2011-08-08 mow the lawn => too tired
--
TODO: 1 of 1 tasks shown

>>> todo.sh -x uncomment 1 after the mower gets fixed
1 X 2011-08-10 2011-08-08 mow the lawn => too tired
TODO: Replaced task with:
1 X 2011-08-10 2011-08-08 mow the lawn => after the mower gets fixed

>>> todo.sh -p -x lstrashable
1 X 2011-08-10 2011-08-08 mow the lawn => after the mower gets fixed
--
TODO: 1 of 1 tasks shown
EOF

cat > todo.txt <<EOF
x 2011-08-10 2011-08-08 mow the lawn => too tired
x 2011-08-10 2011-08-08 pick some flowers => sunny day
EOF
test_todo_session 'uncomment -q confirms replacement' <<'EOF'
>>> todo.sh -p -x lsdo
1 x 2011-08-10 2011-08-08 mow the lawn => too tired
2 x 2011-08-10 2011-08-08 pick some flowers => sunny day
--
TODO: 2 of 2 tasks shown

>>> printf y | todo.sh -x uncomment -q 1 after the mower gets fixed
\
1 x 2011-08-10 2011-08-08 mow the lawn => too tired
TODO: Replaced task with:
1 x 2011-08-10 2011-08-08 mow the lawn => after the mower gets fixed

>>> printf n | todo.sh -x uncomment -q 2 after the mower gets fixed
\
=== 4
EOF

cat > todo.txt <<EOF
 => weird, comment-only task
EOF
test_todo_session 'uncommenting of comment-only task fails' <<EOF
>>> todo.sh -x uncomment 1
TODO: Removal of comment would create empty task.
=== 1
EOF

test_done
