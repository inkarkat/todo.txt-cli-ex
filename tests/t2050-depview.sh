#!/bin/bash
#

test_description='depview action

This test covers the listing of the dependency structure of blocked tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-01 buy the site +house w:1
2012-04-11 +buy beer and tacos
2012-04-11 rent a good movie
2012-04-11 invite @friends for a home cinema evening w:4 w:5
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
TODO: 2 block(s) of 5 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 buy the site +house w:1
2012-02-02 hire an architect +house w:2
2011-01-01 build your dream home +house w:3
2012-04-11 +buy a tv set
2012-04-11 rent a good movie w:5
2012-04-11 invite @friends for a home cinema evening w:6
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
TODO: 2 block(s) of 7 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 build your dream home +house w:2
2012-02-02 hire an architect +house w:3
2012-02-01 buy the site +house w:4
2011-01-01 find a building site +house
2012-04-11 +buy a tv set
2012-04-11 invite @friends for a home cinema evening w:7
2012-04-11 rent a good movie w:5
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
TODO: 2 block(s) of 7 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money
2012-02-01 buy the site +house w:1 w:2
2012-02-02 hire an architect +house w:2 w:3
2011-01-01 build your dream home +house w:3 w:4
2012-04-11 +buy a color tv w:5 w:money
2012-04-11 +buy beer and tacos
2012-04-11 invite @friends for a home cinema evening w:7 w:6
2012-04-11 rent a good movie
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
TODO: 1 block(s) of 8 dependent tasks.
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money
2012-02-01 buy the site +house w:1 w:2
2012-02-02 hire an architect +house w:2 w:3
2011-01-01 build your dream home +house w:3 w:4
2012-04-11 +buy a color tv w:money
2012-04-11 +buy beer and tacos
2012-04-11 invite @friends for a home cinema evening w:7 w:6 w:9
2012-04-11 rent a good movie w:6
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
TODO: 2 block(s) of 9 dependent tasks.
EOF

test_done
