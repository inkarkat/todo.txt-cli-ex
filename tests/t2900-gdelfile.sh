#!/usr/bin/env bash
#

test_description='gdelfile action

This test covers global deletion of TERM(s).
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-08-08 mow the lawn
2011-09-09 watch tv
2011-10-10 clean the bike
EOF

test_todo_session 'usage help on no arguments' <<'EOF'
>>> todo.sh -f gdelfile
usage: todo.sh gdelfile TERM [...] [SRC]
=== 1
EOF

test_todo_session 'no matches' <<'EOF'
>>> todo.sh gdelfile doesNotExist
TODO: The pattern does not match in any line.
=== 1

>>> todo.sh -f gdelfile doesNotExist
TODO: The pattern does not match in any line.
=== 1
EOF

test_todo_session 'global deletions' <<'EOF'
>>> printf y | todo.sh gdelfile the
TODO: Affected lines:
2011-08-08 mow lawn
2011-10-10 clean bike
\
TODO: 2 tasks updated.

>>> todo.sh -p command ls
1 2011-08-08 mow lawn
2 2011-09-09 watch tv
3 2011-10-10 clean bike
--
TODO: 3 of 3 tasks shown
EOF

test_todo_session 'non-existing file' <<EOF
>>> todo.sh gdelfile a doesNotExist.txt
TODO: File ${HOME}/doesNotExist.txt does not exist.
=== 1
EOF

cat > done.txt <<EOF
2011-08-08 go shopping
2011-08-09 go for a walk
EOF

test_todo_session 'global deletions in different file' <<'EOF'
>>> printf y | todo.sh gdelfile 'for a' go done.txt
DONE: Affected lines:
2011-08-08 shopping
2011-08-09 walk
\
DONE: 2 tasks updated.

>>> todo.sh -p command listfile done.txt
1 2011-08-08 shopping
2 2011-08-09 walk
--
DONE: 2 of 2 tasks shown
EOF

test_done
