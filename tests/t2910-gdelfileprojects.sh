#!/usr/bin/env bash
#

test_description='gdelfileprojects action

This test covers global deletion of +projects.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-08-08 mow the lawn
2011-09-09 watch tv
2011-10-10 clean the bike
EOF

test_todo_session 'no matches' <<'EOF'
>>> todo.sh gdelfileprojects
TODO: The pattern does not match in any line.
=== 1
EOF

cat > todo.txt <<EOF
2011-08-08 +chore @home mow the lawn +household
2011-09-09 watch tv @home
2011-10-10 +chore +transportation clean the bike+car
2011-10-11 @work write resignation to boss@badjob
EOF

test_todo_session 'global project deletions' <<'EOF'
>>> printf y | todo.sh gdelfileprojects
TODO: Affected lines:
2011-08-08 @home mow the lawn
2011-10-10 clean the bike+car
\
TODO: 2 tasks updated.

>>> todo.sh -p command ls
1 2011-08-08 @home mow the lawn
2 2011-09-09 watch tv @home
3 2011-10-10 clean the bike+car
4 2011-10-11 @work write resignation to boss@badjob
--
TODO: 4 of 4 tasks shown
EOF

cat > todo.txt <<EOF
2011-08-08 +chore mow the lawn
2011-09-09 watch tv w:+chore
EOF

test_todo_session 'wait marker before +project is also removed' <<'EOF'
>>> TODOTXT_SIGIL_BEFORE_PATTERN='\(w:\)\?' todo.sh -f gdelfileprojects
TODO: 2 tasks updated.

>>> todo.sh -p command ls
1 2011-08-08 mow the lawn
2 2011-09-09 watch tv
--
TODO: 2 of 2 tasks shown
EOF

cat > done.txt <<EOF
2011-08-08 +fun go shopping
2011-08-09 +fitness go for a walk
EOF

test_todo_session 'global project deletions in different file' <<'EOF'
>>> printf y | todo.sh gdelfileprojects done.txt
DONE: Affected lines:
2011-08-08 go shopping
2011-08-09 go for a walk
\
DONE: 2 tasks updated.
EOF

test_done
