#!/bin/bash
#

test_description='defragment action

This test covers the cleaning of empty lines while adapting cross-task
references, which is important to maintain the wait dependencies.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-02 obtain a bank loan +house w:money
2012-02-03 buy the site +house w:1 w:2
2012-02-03 hire an architect +house w:2 w:3
2012-03-01 build your dream home +house w:3 w:4
2012-03-11 +buy a color tv w:money
2012-03-12 +buy beer and tacos
2012-03-13 invite @friends for a home cinema evening w:7 w:6 w:9
2012-03-14 rent a good movie w:6
2012-03-18 go jogging w:11
2012-03-18 purchase new walking shoes
EOF
test_todo_session 'defragment no changes' <<EOF
>>> todo.sh -p command ls
01 2011-01-01 find a building site +house
02 2012-02-02 obtain a bank loan +house w:money
03 2012-02-03 buy the site +house w:1 w:2
04 2012-02-03 hire an architect +house w:2 w:3
05 2012-03-01 build your dream home +house w:3 w:4
06 2012-03-11 +buy a color tv w:money
07 2012-03-12 +buy beer and tacos
08 2012-03-13 invite @friends for a home cinema evening w:7 w:6 w:9
09 2012-03-14 rent a good movie w:6
10 2012-03-18 go jogging w:11
11 2012-03-18 purchase new walking shoes
--
TODO: 11 of 11 tasks shown

>>> todo.sh defragment

>>> todo.sh -p command ls
01 2011-01-01 find a building site +house
02 2012-02-02 obtain a bank loan +house w:money
03 2012-02-03 buy the site +house w:1 w:2
04 2012-02-03 hire an architect +house w:2 w:3
05 2012-03-01 build your dream home +house w:3 w:4
06 2012-03-11 +buy a color tv w:money
07 2012-03-12 +buy beer and tacos
08 2012-03-13 invite @friends for a home cinema evening w:7 w:6 w:9
09 2012-03-14 rent a good movie w:6
10 2012-03-18 go jogging w:11
11 2012-03-18 purchase new walking shoes
--
TODO: 11 of 11 tasks shown
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-02 obtain a bank loan +house w:money
2012-02-03 buy the site +house w:1 w:2
2012-02-03 hire an architect +house w:2 w:3
2012-03-01 build your dream home +house w:3 w:4
2012-03-11 +buy a color tv w:money
2012-03-12 +buy beer and tacos
2012-03-13 invite @friends for a home cinema evening w:7 w:6 w:9
2012-03-14 rent a good movie w:6
2012-03-18 buy new walking shoes


2012-03-18 go jogging w:10

EOF
test_todo_session 'defragment no adaptations' <<EOF
>>> todo.sh -p command ls
01 2011-01-01 find a building site +house
02 2012-02-02 obtain a bank loan +house w:money
03 2012-02-03 buy the site +house w:1 w:2
04 2012-02-03 hire an architect +house w:2 w:3
05 2012-03-01 build your dream home +house w:3 w:4
06 2012-03-11 +buy a color tv w:money
07 2012-03-12 +buy beer and tacos
08 2012-03-13 invite @friends for a home cinema evening w:7 w:6 w:9
09 2012-03-14 rent a good movie w:6
10 2012-03-18 buy new walking shoes
13 2012-03-18 go jogging w:10
--
TODO: 11 of 11 tasks shown

>>> todo.sh defragment

>>> todo.sh -p command ls
01 2011-01-01 find a building site +house
02 2012-02-02 obtain a bank loan +house w:money
03 2012-02-03 buy the site +house w:1 w:2
04 2012-02-03 hire an architect +house w:2 w:3
05 2012-03-01 build your dream home +house w:3 w:4
06 2012-03-11 +buy a color tv w:money
07 2012-03-12 +buy beer and tacos
08 2012-03-13 invite @friends for a home cinema evening w:7 w:6 w:9
09 2012-03-14 rent a good movie w:6
10 2012-03-18 buy new walking shoes
11 2012-03-18 go jogging w:10
--
TODO: 11 of 11 tasks shown
EOF

cat > todo.txt <<EOF

2011-01-01 find a building site +house

2012-02-02 obtain a bank loan +house w:money
2012-02-03 buy the site +house w:2 w:4
2012-02-03 hire an architect +house w:4 w:5



2012-03-01 build your dream home +house w:5 w:6
2012-03-11 +buy a color tv w:money

2012-03-12 +buy beer and tacos
2012-03-13 invite @friends for a home cinema evening w:11 w:10 w:15
2012-03-14 rent a good movie w:11
2012-03-18 go jogging w:18

2012-03-18 purchase new walking shoes
EOF
test_todo_session 'defragment adaptations' <<EOF
>>> todo.sh -p command ls
02 2011-01-01 find a building site +house
04 2012-02-02 obtain a bank loan +house w:money
05 2012-02-03 buy the site +house w:2 w:4
06 2012-02-03 hire an architect +house w:4 w:5
10 2012-03-01 build your dream home +house w:5 w:6
11 2012-03-11 +buy a color tv w:money
13 2012-03-12 +buy beer and tacos
14 2012-03-13 invite @friends for a home cinema evening w:11 w:10 w:15
15 2012-03-14 rent a good movie w:11
16 2012-03-18 go jogging w:18
18 2012-03-18 purchase new walking shoes
--
TODO: 11 of 11 tasks shown

>>> todo.sh defragment

>>> todo.sh -p command ls
01 2011-01-01 find a building site +house
02 2012-02-02 obtain a bank loan +house w:money
03 2012-02-03 buy the site +house w:1 w:2
04 2012-02-03 hire an architect +house w:2 w:3
05 2012-03-01 build your dream home +house w:3 w:4
06 2012-03-11 +buy a color tv w:money
07 2012-03-12 +buy beer and tacos
08 2012-03-13 invite @friends for a home cinema evening w:06 w:05 w:09
09 2012-03-14 rent a good movie w:06
10 2012-03-18 go jogging w:11
11 2012-03-18 purchase new walking shoes
--
TODO: 11 of 11 tasks shown
EOF

test_done
