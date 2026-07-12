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

test_done
