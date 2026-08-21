#!/usr/bin/env bash
#

test_description='do action comment template expansion

This test covers the expansion of a ~> comment template via the do action.
'
. ./test-lib.sh

cat > todo.txt <<'EOF'
2009-02-01 a simple task => easily done
2009-02-02 weekly cleanup ~> successfully done
EOF
test_todo_session 'turn a static comment template into a comment' <<EOF
>>> todo.sh -a -f do 2
2 x 2009-02-13 2009-02-02 weekly cleanup => successfully done
TODO: 2 marked as done.

>>> todo.sh -p -x lsdo
2 x 2009-02-13 2009-02-02 weekly cleanup => successfully done
--
TODO: 1 of 2 tasks shown
EOF

cat > todo.txt <<'EOF'
2009-02-01 a simple task => easily done
2009-02-02 $WEEKLY cleanup ~> with ${WHAT^^} in $TIMESPAN
2009-02-03 task cleanup ~> on a total of $(sed -ne \$= "$TODO_FILE") tasks
2009-02-03 count stuff ~> $(seq 1 3) and `seq 5 8`
EOF
test_todo_session 'turn a comment template into a comment' <<'EOF'
>>> WEEKLY=thisShouldNotMatter WHAT=charisma TIMESPAN='5 minutes' todo.sh -a -f do 2
2 x 2009-02-13 2009-02-02 $WEEKLY cleanup => with CHARISMA in 5 minutes
TODO: 2 marked as done.

>>> todo.sh -p -x lsdo
2 x 2009-02-13 2009-02-02 $WEEKLY cleanup => with CHARISMA in 5 minutes
--
TODO: 1 of 4 tasks shown

>>> todo.sh -a -f do 3
3 x 2009-02-13 2009-02-03 task cleanup => on a total of 4 tasks
TODO: 3 marked as done.

>>> todo.sh -a -f do 4
4 x 2009-02-13 2009-02-03 count stuff => 1 2 3 and 5 6 7 8
TODO: 4 marked as done.
EOF

cat > todo.txt <<'EOF'
2009-02-02 broken ~> with ${WHAT^^} but ` is bad
EOF
test_todo_session 'syntax error in comment template prints warning and keeps original task content' <<'EOF'
>>> WHAT=charisma todo.sh -a -f do 1
TODO: Could not expand comment template: ~> with ${WHAT^^} but ` is bad
1 x 2009-02-13 2009-02-02 broken ~> with ${WHAT^^} but ` is bad
TODO: 1 marked as done.
EOF

cat > todo.txt <<'EOF'
2009-02-01 a simple task
2009-02-02 cleanup ~> with ${WHAT:-friends} in ${TIMESPAN:-no time at all}
EOF
test_todo_session 'user-supplied COMMENT is appended and considered for comment template' <<'EOF'
>>> todo.sh -a -f do 2 "; that's how I prefer it"
2 2009-02-02 cleanup ~> with ${WHAT:-friends} in ${TIMESPAN:-no time at all}; that's how I prefer it
2 x 2009-02-13 2009-02-02 cleanup => with friends in no time at all; that's how I prefer it
TODO: 2 marked as done.

>>> FEELING=boring todo.sh -a -f do 1 '~> $FEELING'
1 2009-02-01 a simple task ~> $FEELING
1 x 2009-02-13 2009-02-01 a simple task => boring
TODO: 1 marked as done.

>>> todo.sh -p -x lsdo
1 x 2009-02-13 2009-02-01 a simple task => boring
2 x 2009-02-13 2009-02-02 cleanup => with friends in no time at all; that's how I prefer it
--
TODO: 2 of 2 tasks shown
EOF

cat > todo.txt <<'EOF'
2009-02-13 a simple task {2009-02-14} ~> easily done
2009-02-13 count stuff {2009-03-13} ~> $(seq 1 3) and `seq 5 8`
EOF
test_todo_session 'a recurring task restores the comment template' <<'EOF'
>>> todo.sh -a -f do 1
1 x 2009-02-13 2009-02-13 a simple task {2009-02-14} => easily done
TODO: 1 marked as done.
3 2009-02-13 a simple task {2009-02-14} t:2009-02-14 => easily done
TODO: 3 added.
TODO: Next scheduled for 2009-02-14, in 1 day
3 2009-02-13 a simple task {2009-02-14} t:2009-02-14 => easily done
TODO: Replaced task with:
3 2009-02-13 a simple task {2009-02-14} t:2009-02-14 ~> easily done

>>> todo.sh -a -f do 2
2 x 2009-02-13 2009-02-13 count stuff {2009-03-13} => 1 2 3 and 5 6 7 8
TODO: 2 marked as done.
4 2009-02-13 count stuff {2009-03-13} t:2009-03-13 => 1 2 3 and 5 6 7 8
TODO: 4 added.
TODO: Next scheduled for 2009-03-13, in 28 days
4 2009-02-13 count stuff {2009-03-13} t:2009-03-13 => 1 2 3 and 5 6 7 8
TODO: Replaced task with:
4 2009-02-13 count stuff {2009-03-13} t:2009-03-13 ~> $(seq 1 3) and `seq 5 8`
EOF

test_done
