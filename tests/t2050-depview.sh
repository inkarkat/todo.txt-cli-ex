#!/bin/bash
#

test_description='depview action

This test covers the listing of the dependency structure of blocked tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-02 buy the site +house w:1
2012-03-11 +buy beer and tacos
2012-03-12 rent a good movie
2012-03-13 invite @friends for a home cinema evening w:4 w:5
EOF

test_todo_session 'depview one-level dependency' <<'EOF'
>>> todo.sh -p depview
3 buy the site
  1 find a building site
\
6 invite for a home cinema evening
  4 beer and tacos
  5 rent a good movie
--
TODO: 2 blocks of 5 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 buy the site +house w:1
2012-02-02 hire an architect +house w:2
2012-03-11 build your dream home +house w:3
2012-03-12 +buy a tv set
2012-03-13 rent a good movie w:5
2012-03-14 invite @friends for a home cinema evening w:6
EOF

test_todo_session 'depview two-level dependency' <<'EOF'
>>> todo.sh -p depview
4 build your dream home
  3 hire an architect
    2 buy the site
      1 find a building site
\
7 invite for a home cinema evening
  6 rent a good movie
    5 a tv set
--
TODO: 2 blocks of 7 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 build your dream home +house w:2
2012-02-01 hire an architect +house w:3
2012-02-02 buy the site +house w:4
2012-03-11 find a building site +house
2012-03-12 +buy a tv set
2012-03-13 invite @friends for a home cinema evening w:7
2012-03-14 rent a good movie w:5
EOF

test_todo_session 'depview inverted two-level dependency' <<'EOF'
>>> todo.sh -p depview
1 build your dream home
  2 hire an architect
    3 buy the site
      4 find a building site
\
6 invite for a home cinema evening
  7 rent a good movie
    5 a tv set
--
TODO: 2 blocks of 7 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money
2012-02-02 buy the site +house w:1 w:2
2012-03-11 hire an architect +house w:2 w:3
2012-03-12 build your dream home +house w:3 w:4
2012-03-13 +buy a color tv w:5 w:money
2012-03-13 +buy beer and tacos
2012-03-14 invite @friends for a home cinema evening w:7 w:6
2012-03-14 rent a good movie
EOF
test_todo_session 'depview single block with duplicated low-level dependency' <<'EOF'
>>> todo.sh -p depview
8 invite for a home cinema evening
  7 beer and tacos
  6 a color tv w:money
    5 build your dream home
      4 hire an architect
        3 buy the site
          1 find a building site
          2 obtain a bank loan w:money
        2 obtain a bank loan w:money
      3 buy the site
        1 find a building site
        2 obtain a bank loan w:money
--
TODO: 1 block of 8 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money
2012-02-02 buy the site +house w:1 w:2
2012-03-11 hire an architect +house w:2 w:3
2012-03-12 build your dream home +house w:3 w:4
2012-03-13 +buy a color tv w:money
2012-03-13 +buy beer and tacos
2012-03-14 invite @friends for a home cinema evening w:7 w:6 w:9
2012-03-14 rent a good movie w:6
EOF
test_todo_session 'depview blocks with duplicated low-level dependency' <<'EOF'
>>> todo.sh -p depview
5 build your dream home
  4 hire an architect
    3 buy the site
      1 find a building site
      2 obtain a bank loan w:money
    2 obtain a bank loan w:money
  3 buy the site
    1 find a building site
    2 obtain a bank loan w:money
\
8 invite for a home cinema evening
  7 beer and tacos
  9 rent a good movie
    6 a color tv w:money
  6 a color tv w:money
--
TODO: 2 blocks of 9 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-02 buy the site +house w:1
2012-03-11 task a w:5
2012-03-12 task b w:4
2012-03-13 task c
2012-03-13 +buy beer and tacos
2012-03-14 rent a good movie
2012-03-14 invite @friends for a home cinema evening w:7 w:8
EOF

test_todo_session 'depview direct circularity' <<'EOF'
>>> todo.sh -p depview
3 buy the site
  1 find a building site
\
9 invite for a home cinema evening
  7 beer and tacos
  8 rent a good movie
--
TODO: 2 blocks of 7 dependent tasks.
Note: Some task dependencies contain a cycle and are not shown.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-02 buy the site +house w:1
2012-03-11 task a w:6
2012-03-12 task b w:4
2012-03-13 task c w:5
2012-03-13 +buy beer and tacos
2012-03-14 rent a good movie
2012-03-14 invite @friends for a home cinema evening w:7 w:8
EOF

test_todo_session 'depview indirect circularity' <<'EOF'
>>> todo.sh -p depview
3 buy the site
  1 find a building site
\
9 invite for a home cinema evening
  7 beer and tacos
  8 rent a good movie
--
TODO: 2 blocks of 8 dependent tasks.
Note: Some task dependencies contain a cycle and are not shown.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money
2012-02-02 buy the site +house w:1 w:2
2012-03-11 hire an architect +house w:2 w:3
2012-03-12 build your dream home +house w:3 w:4
2012-03-13 +buy a color tv w:money
2012-03-13 +buy beer and tacos
2012-03-14 invite @friends for a home cinema evening w:7 w:6 w:9
2012-03-14 rent a good movie w:6
EOF
test_todo_session 'depview highlighting' <<'EOF'
>>> todo.sh command pri 3 b
3 (B) 2012-02-02 buy the site +house w:1 w:2
TODO: 3 prioritized (B).

>>> TERM_COLORS=16 todo.sh depview
[7m5[0m build your dream home
  [7m4[0m hire an architect
    [0;32m[7m3[0;32m (B) buy the site[0m
      [7m1[0m find a building site
      [0;33m[7m2[0;33m obtain a bank loan w:[7;33mmoney[0;33m[0m
    [0;33m[7m2[0;33m obtain a bank loan w:[7;33mmoney[0;33m[0m
  [0;32m[7m3[0;32m (B) buy the site[0m
    [7m1[0m find a building site
    [0;33m[7m2[0;33m obtain a bank loan w:[7;33mmoney[0;33m[0m
\
[7m8[0m invite for a home cinema evening
  [7m7[0m beer and tacos
  [7m9[0m rent a good movie
    [0;33m[7m6[0;33m a color tv w:[7;33mmoney[0;33m[0m
  [0;33m[7m6[0;33m a color tv w:[7;33mmoney[0;33m[0m
--
TODO: 2 blocks of 9 dependent tasks.
EOF

test_done
