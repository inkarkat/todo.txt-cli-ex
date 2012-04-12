#!/bin/bash
#

test_description='blockerview action

This test covers the summarized listing of blocked tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-02 buy the site +house w:1 w:2
2012-02-03 hire an architect +house w:2 w:3
2012-03-01 build your dream home +house w:3 w:4
2012-03-11 +buy a color tv w:5 w:money
2012-03-11 +buy beer and tacos
2012-03-12 invite @friends for a home cinema evening w:7 w:6 w:8
2012-03-12 rent a good movie w:6
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
4 hire an architect w:2
5 build your dream home w:4
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
4 hire an architect w:2
5 build your dream home w:4
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

test_todo_session 'blockerview highlighting' <<'EOF'
>>> todo.sh command pri 3 b
3 (B) 2012-02-02 buy the site +house w:1 w:2
TODO: 3 prioritized (B).

>>> todo.sh blockerview
--- salary increase ---
[0;38;5;136m[7m2[0;38;5;136m obtain a bank loan w:[7;38;5;136mmoney[0;38;5;136m[0m
\
--- [7m1[0m find a building site ---
[0;32m[7m3[0;32m (B) buy the site w:[7;38;5;136m2[0m[0;32m
\
--- [0;38;5;136m[7m2[0;38;5;136m obtain a bank loan w:[7;38;5;136mmoney[0;38;5;136m w:[7;38;5;136msalary increase[0;38;5;136m[0m ---
[0;32m[7m3[0;32m (B) buy the site w:[7;38;5;136m1[0m[0;32m
[0;38;5;136m[7m4[0;38;5;136m hire an architect w:[7m3[0;38;5;136m[0m
\
--- [0;32m[7m3[0;32m (B) buy the site w:[7m1[0;32m w:[7;38;5;136m2[0m[0;32m ---
[0;38;5;136m[7m4[0;38;5;136m hire an architect w:[7m2[0;38;5;136m[0m
[0;38;5;136m[7m5[0;38;5;136m build your dream home w:[7m4[0;38;5;136m[0m
\
--- [0;38;5;136m[7m4[0;38;5;136m hire an architect w:[7m2[0;38;5;136m w:[7m3[0;38;5;136m[0m ---
[0;38;5;136m[7m5[0;38;5;136m build your dream home w:[7m3[0;38;5;136m[0m
\
--- [0;38;5;136m[7m5[0;38;5;136m build your dream home w:[7m3[0;38;5;136m w:[7m4[0;38;5;136m[0m ---
[0;38;5;136m[7m6[0;38;5;136m a color tv w:[7;38;5;136mmoney[0;38;5;136m[0m
\
--- [0;38;5;136m[7m6[0;38;5;136m a color tv w:[7m5[0;38;5;136m w:[7;38;5;136mmoney[0;38;5;136m[0m ---
[0;38;5;136m[7m8[0;38;5;136m invite for a home cinema evening w:[7m7[0;38;5;136m w:[7m8[0;38;5;136m[0m
[7m9[0m rent a good movie
\
--- [7m7[0m beer and tacos ---
[0;38;5;136m[7m8[0;38;5;136m invite for a home cinema evening w:[7m6[0;38;5;136m w:[7m8[0;38;5;136m[0m
\
--- [0;38;5;136m[7m8[0;38;5;136m invite for a home cinema evening w:[7m7[0;38;5;136m w:[7m6[0;38;5;136m w:[7m8[0;38;5;136m[0m ---
[0;38;5;136m[7m8[0;38;5;136m invite for a home cinema evening w:[7m7[0;38;5;136m w:[7m6[0;38;5;136m[0m
\
--- money ---
[0;38;5;136m[7m2[0;38;5;136m obtain a bank loan w:[7;38;5;136msalary increase[0;38;5;136m[0m
[0;38;5;136m[7m6[0;38;5;136m a color tv w:[7m5[0;38;5;136m[0m
\
--
TODO: 3 blocked task(s) waiting for 2 blocker(s).
TODO: 11 blocked task(s) waiting for 8 dependent task(s).
EOF

test_done
