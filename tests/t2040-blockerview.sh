#!/bin/bash
#

test_description='blockerview action

This test covers the summarized listing of blocked tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-01 buy the site +house w:1 w:2
2012-02-02 hire an architect +house w:2 w:3
2011-01-01 build your dream home +house w:3 w:4
2012-04-11 +buy a color tv w:5 w:money
2012-04-11 +buy beer and tacos
2012-04-11 invite @friends for a home cinema evening w:7 w:6 w:8
2012-04-11 rent a good movie w:6
EOF

test_todo_session 'blockerview' <<'EOF'
>>> todo.sh -p blockerview
--- salary increase ---
2 obtain a bank loan w:money
\
--- 1 find a building site ---
3 buy the site w:2
\
--- 2 obtain a bank loan w:money w:(salary increase) ---
3 buy the site w:1
4 hire an architect w:3
\
--- 3 buy the site w:1 w:2 ---
5 build your dream home w:4
4 hire an architect w:2
\
--- 4 hire an architect w:2 w:3 ---
5 build your dream home w:3
\
--- 5 build your dream home w:3 w:4 ---
6 a color tv w:money
\
--- 6 a color tv w:5 w:money ---
8 invite for a home cinema evening w:7 w:8
9 rent a good movie
\
--- 7 beer and tacos ---
8 invite for a home cinema evening w:6 w:8
\
--- 8 invite for a home cinema evening w:7 w:6 w:8 ---
8 invite for a home cinema evening w:7 w:6
\
--- money ---
2 obtain a bank loan w:(salary increase)
6 a color tv w:5
\
--
TODO: 3 blocked task(s) waiting for 2 blocker(s).
TODO: 11 blocked task(s) waiting for 8 dependent task(s).
EOF

test_todo_session 'blockerview TERM' <<'EOF'
>>> todo.sh -p blockerview +house
--- salary increase ---
2 obtain a bank loan w:money
\
--- 1 find a building site ---
3 buy the site w:2
\
--- 2 obtain a bank loan w:money w:(salary increase) ---
3 buy the site w:1
4 hire an architect w:3
\
--- 3 buy the site w:1 w:2 ---
5 build your dream home w:4
4 hire an architect w:2
\
--- 4 hire an architect w:2 w:3 ---
5 build your dream home w:3
\
--- money ---
2 obtain a bank loan w:(salary increase)
\
--
TODO: 2 blocked task(s) waiting for 2 blocker(s).
TODO: 6 blocked task(s) waiting for 4 dependent task(s).

>>> todo.sh -p blockerview +buy
--- 5 build your dream home w:3 w:4 ---
6 a color tv w:money
\
--- money ---
6 a color tv w:5
\
--
TODO: 1 blocked task(s) waiting for 1 blocker(s).
TODO: 1 blocked task(s) waiting for 1 dependent task(s).
EOF

test_done
