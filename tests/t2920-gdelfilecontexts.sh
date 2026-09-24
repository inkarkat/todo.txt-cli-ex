#!/usr/bin/env bash
#

test_description='gdelfilecontexts action

This test covers global deletion of @contexts.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-08-08 mow the lawn
2011-09-09 watch tv
2011-10-10 clean the bike
EOF

test_todo_session 'no matches' <<'EOF'
>>> todo.sh gdelfilecontexts
TODO: The pattern does not match in any line.
=== 1
EOF

cat > todo.txt <<EOF
2011-08-08 +chore @home mow the lawn +household
2011-09-09 watch tv @home
2011-10-10 +chore +transportation clean the bike+car
2011-10-11 @work write resignation to boss@badjob
EOF

test_todo_session 'global context deletions' <<'EOF'
>>> printf y | todo.sh gdelfilecontexts
TODO: Affected lines:
2011-08-08 +chore mow the lawn +household
2011-09-09 watch tv
2011-10-11 write resignation to boss@badjob
\
TODO: 3 tasks updated.

>>> todo.sh -p command ls
1 2011-08-08 +chore mow the lawn +household
2 2011-09-09 watch tv
3 2011-10-10 +chore +transportation clean the bike+car
4 2011-10-11 write resignation to boss@badjob
--
TODO: 4 of 4 tasks shown
EOF

test_done
