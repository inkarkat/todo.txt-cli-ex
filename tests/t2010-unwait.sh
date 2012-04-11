#!/bin/bash
#

test_description='unwait action

This test covers the un-blocking of tasks.
'
. ./test-lib.sh

set_up()
{
    cat > todo.txt <<EOF
2011-01-01 find a building site
2012-02-01 obtain a bank loan w:money w:(salary increase)
2012-02-01 buy the site w:1 w:2
2012-02-02 hire an architect w:2 w:3
2011-01-01 build your dream home w:3 w:4
2012-04-11 buy a color tv w:5 w:money
EOF
}

set_up
test_todo_session 'unblock REASON' <<EOF
>>> todo.sh -p unwait "salary increase"
2 2012-02-01 obtain a bank loan w:money
TODO: 2 had blocker(s) removed; still blocked.

>>> todo.sh -p unwait money
2 2012-02-01 obtain a bank loan
TODO: 2 unblocked.
6 2012-04-11 buy a color tv w:5
TODO: 6 had blocker(s) removed; still blocked.

>>> todo.sh -p command ls
5 2011-01-01 build your dream home w:3 w:4
1 2011-01-01 find a building site
3 2012-02-01 buy the site w:1 w:2
2 2012-02-01 obtain a bank loan
4 2012-02-02 hire an architect w:2 w:3
6 today buy a color tv w:5
--
TODO: 6 of 6 tasks shown
EOF

set_up
test_todo_session 'unblock multiple-ITEM# REASON' <<EOF
>>> todo.sh -p unwait 2,6 money
2 2012-02-01 obtain a bank loan w:(salary increase)
TODO: 2 had blocker(s) removed; still blocked.
6 2012-04-11 buy a color tv w:5
TODO: 6 had blocker(s) removed; still blocked.

>>> todo.sh -p unwait 2,5,6 "salary increase"
2 2012-02-01 obtain a bank loan
TODO: 2 unblocked.
TODO: 5 not blocked
=== 1
EOF

set_up
test_todo_session 'unblock ITEM# REASON' <<EOF
>>> todo.sh -p unwait 2 money
2 2012-02-01 obtain a bank loan w:(salary increase)
TODO: 2 had blocker(s) removed; still blocked.

>>> todo.sh -p unwait 6 money
6 2012-04-11 buy a color tv w:5
TODO: 6 had blocker(s) removed; still blocked.

>>> todo.sh -p unwait 1 money
TODO: 1 not blocked
=== 1
EOF

set_up
test_todo_session 'unwait DEPITEM#' <<EOF
>>> todo.sh -p unwait for 1
3 2012-02-01 buy the site w:2
TODO: 3 had blocker(s) removed; still blocked.

>>> todo.sh -p unwait for 2
3 2012-02-01 buy the site
TODO: 3 unblocked.
4 2012-02-02 hire an architect w:3
TODO: 4 had blocker(s) removed; still blocked.

>>> todo.sh -p command ls
5 2011-01-01 build your dream home w:3 w:4
1 2011-01-01 find a building site
3 2012-02-01 buy the site
2 2012-02-01 obtain a bank loan w:money w:(salary increase)
4 2012-02-02 hire an architect w:3
6 today buy a color tv w:5 w:money
--
TODO: 6 of 6 tasks shown
EOF

set_up
test_todo_session 'unwait multiple-DEPITEM#' <<EOF
>>> todo.sh -p unwait for 1,2
3 2012-02-01 buy the site
TODO: 3 unblocked.
4 2012-02-02 hire an architect w:3
TODO: 4 had blocker(s) removed; still blocked.
EOF

set_up
test_todo_session 'unwait ITEM# for DEPITEM#' <<EOF
>>> todo.sh -p unwait 4 for 2
4 2012-02-02 hire an architect w:3
TODO: 4 had blocker(s) removed; still blocked.

>>> todo.sh -p command ls
5 2011-01-01 build your dream home w:3 w:4
1 2011-01-01 find a building site
3 2012-02-01 buy the site w:1 w:2
2 2012-02-01 obtain a bank loan w:money w:(salary increase)
4 2012-02-02 hire an architect w:3
6 today buy a color tv w:5 w:money
--
TODO: 6 of 6 tasks shown

>>> todo.sh -p unwait 3,4,5 for 2
3 2012-02-01 buy the site w:1
TODO: 3 had blocker(s) removed; still blocked.
TODO: 4 not blocked
=== 1
EOF

set_up
test_todo_session 'unwait ITEM#' <<EOF
>>> todo.sh -p unwait 6
6 2012-04-11 buy a color tv
TODO: 6 unblocked.

>>> todo.sh -p unwait 2,3
2 2012-02-01 obtain a bank loan
TODO: 2 unblocked.
3 2012-02-01 buy the site
TODO: 3 unblocked.

>>> todo.sh -p command ls
5 2011-01-01 build your dream home w:3 w:4
1 2011-01-01 find a building site
3 2012-02-01 buy the site
2 2012-02-01 obtain a bank loan
4 2012-02-02 hire an architect w:2 w:3
6 today buy a color tv
--
TODO: 6 of 6 tasks shown
EOF

set_up
test_todo_session 'unwait ITEM# PRIORITY' <<EOF
>>> todo.sh -p unwait 2 b
2 2012-02-01 obtain a bank loan
TODO: 2 unblocked.
2 (B) 2012-02-01 obtain a bank loan
TODO: 2 prioritized (B).

>>> todo.sh -p command ls
2 (B) 2012-02-01 obtain a bank loan
5 2011-01-01 build your dream home w:3 w:4
1 2011-01-01 find a building site
3 2012-02-01 buy the site w:1 w:2
4 2012-02-02 hire an architect w:2 w:3
6 today buy a color tv w:5 w:money
--
TODO: 6 of 6 tasks shown
EOF

test_done
