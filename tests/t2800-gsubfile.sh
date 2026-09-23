#!/usr/bin/env bash
#

test_description='gsubfile action

This test covers global substitution of PATTERN(s).
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-08-08 mow the lawn
2011-09-09 watch tv
2011-10-10 clean the bike
EOF

test_todo_session 'usage help on no arguments' <<'EOF'
>>> todo.sh -f gsubfile
usage: todo.sh gsubfile PATTERN REPLACEMENT [PATTERN REPLACEMENT ...] [SRC]
=== 1
EOF

test_todo_session 'no matches' <<'EOF'
>>> todo.sh gsubfile doesNotExist something
TODO: The pattern does not match in any line.
=== 1

>>> todo.sh -f gsubfile doesNotExist something
TODO: The pattern does not match in any line.
=== 1
EOF

test_todo_session 'global substitutions' <<'EOF'
>>> printf y | todo.sh gsubfile the my
TODO: Affected lines:
2011-08-08 mow my lawn
2011-10-10 clean my bike
\
TODO: 2 tasks updated.

>>> todo.sh -p command ls
1 2011-08-08 mow my lawn
2 2011-09-09 watch tv
3 2011-10-10 clean my bike
--
TODO: 3 of 3 tasks shown

>>> printf y | todo.sh gsubfile '\b[[:lower:]]' '\u&'
TODO: Affected lines:
2011-08-08 Mow My Lawn
2011-09-09 Watch Tv
2011-10-10 Clean My Bike
\
TODO: 3 tasks updated.
EOF

test_todo_session 'multiple forced substitutions' <<'EOF'
>>> todo.sh -f gsubfile Tv Television Bike 'dirty &'
TODO: 2 tasks updated.

>>> todo.sh -p command ls
1 2011-08-08 Mow My Lawn
2 2011-09-09 Watch Television
3 2011-10-10 Clean My dirty Bike
--
TODO: 3 of 3 tasks shown
EOF

test_todo_session 'non-existing file' <<EOF
>>> todo.sh gsubfile a b doesNotExist.txt
TODO: File ${HOME}/doesNotExist.txt does not exist.
=== 1
EOF

cat > done.txt <<EOF
2011-08-08 go shopping
2011-08-09 go for a walk
EOF

test_todo_session 'global substitutions in different file' <<'EOF'
>>> printf y | todo.sh gsubfile go do 'for a' the done.txt
DONE: Affected lines:
2011-08-08 do shopping
2011-08-09 do the walk
\
DONE: 2 tasks updated.

>>> todo.sh -p command listfile done.txt
1 2011-08-08 do shopping
2 2011-08-09 do the walk
--
DONE: 2 of 2 tasks shown
EOF

test_done
