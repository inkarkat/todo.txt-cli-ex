#!/bin/bash
#

test_description='archive action

This test covers the archiving of done tasks while adapting cross-task
references when cleaning out empty lines, which is important to maintain the
wait dependencies. It verifies that the defragment action is actually used.
'
. ./test-lib.sh

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

x 2012-03-19 2012-03-18 purchase new walking shoes
EOF
test_todo_session 'archive with defragment' <<EOF
>>> todo.sh -p -x command ls
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
18 x 2012-03-19 2012-03-18 purchase new walking shoes
--
TODO: 11 of 11 tasks shown

>>> TODOTXT_BACKUP_COMMAND=none todo.sh -p -x archive
18 x 2012-03-19 2012-03-18 purchase new walking shoes
--
TODO: 1 of 11 tasks archived
TODO: No tasks have been trashed.
16 2012-03-18 go jogging w:18
TODO: Invalidate reference to cleared task 18

>>> todo.sh -p -x command ls
01 2011-01-01 find a building site +house
02 2012-02-02 obtain a bank loan +house w:money
03 2012-02-03 buy the site +house w:1 w:2
04 2012-02-03 hire an architect +house w:2 w:3
05 2012-03-01 build your dream home +house w:3 w:4
06 2012-03-11 +buy a color tv w:money
07 2012-03-12 +buy beer and tacos
08 2012-03-13 invite @friends for a home cinema evening w:6 w:5 w:9
09 2012-03-14 rent a good movie w:6
10 2012-03-18 go jogging w:???
--
TODO: 10 of 10 tasks shown
EOF

test_done
