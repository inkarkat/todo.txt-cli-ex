#!/bin/bash
#

test_description='listblockers action

This test covers the listing of blockers of tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-01 obtain a bank loan +house w:money w:(salary increase)
2012-02-02 buy the site +house w:1 w:2
2012-02-03 hire an architect +house w:2 w:3
2011-03-01 build your dream home +house w:3 w:4
2012-03-11 +buy a color tv w:5 w:money
2012-03-11 +buy beer and tacos
2012-03-12 invite @friends for a home cinema evening w:7 w:6 w:8
2012-03-12 rent a good movie w:6
EOF

test_todo_session 'listblockers' <<EOF
>>> todo.sh -p listblockers
money
salary increase
EOF

test_todo_session 'listblockers TERM' <<EOF
>>> todo.sh -p listblockers +buy
money

>>> todo.sh -p listblockers @friends
EOF

test_done
