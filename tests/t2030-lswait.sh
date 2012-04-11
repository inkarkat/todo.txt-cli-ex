#!/bin/bash
#

test_description='lswait action

This test covers the listing of blocked tasks.
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

test_todo_session 'lswait' <<EOF
>>> todo.sh -p lswait
5 2011-01-01 build your dream home +house w:3 w:4
3 2012-02-01 buy the site +house w:1 w:2
2 2012-02-01 obtain a bank loan +house w:money w:(salary increase)
4 2012-02-02 hire an architect +house w:2 w:3
6 today +buy a color tv w:5 w:money
8 today invite @friends for a home cinema evening w:7 w:6 w:8
9 today rent a good movie w:6
--
TODO: 7 blocked of 9 tasks shown
EOF

test_todo_session 'lswait TERM' <<EOF
>>> todo.sh -p lswait +house
5 2011-01-01 build your dream home +house w:3 w:4
3 2012-02-01 buy the site +house w:1 w:2
2 2012-02-01 obtain a bank loan +house w:money w:(salary increase)
4 2012-02-02 hire an architect +house w:2 w:3
--
TODO: 4 blocked of 9 tasks shown

>>> todo.sh -p lswait w:money
2 2012-02-01 obtain a bank loan +house w:money w:(salary increase)
6 today +buy a color tv w:5 w:money
--
TODO: 2 blocked of 9 tasks shown

>>> todo.sh -p lswait find
--
TODO: 0 blocked of 9 tasks shown
EOF

test_todo_session 'lswait for DEPITEM#' <<EOF
>>> todo.sh -p lswait for 1
3 2012-02-01 buy the site +house w:1 w:2
--
TODO: 1 of 9 tasks shown

>>> todo.sh -p lswait for 2
3 2012-02-01 buy the site +house w:1 w:2
4 2012-02-02 hire an architect +house w:2 w:3
--
TODO: 2 of 9 tasks shown

>>> todo.sh -p lswait for 9
TODO: No tasks have a dependency to 9.
=== 1
EOF

test_todo_session 'lswait for multiple-DEPITEM#' <<EOF
>>> todo.sh -p lswait for 2,3
5 2011-01-01 build your dream home +house w:3 w:4
3 2012-02-01 buy the site +house w:1 w:2
4 2012-02-02 hire an architect +house w:2 w:3
--
TODO: 3 of 9 tasks shown

>>> todo.sh -p lswait for 9,10 11
TODO: No tasks have a dependency to 9, 10, 11.
=== 1
EOF

test_todo_session 'lswait for REASON' <<EOF
>>> todo.sh -p lswait for "salary increase"
2 2012-02-01 obtain a bank loan +house w:money w:(salary increase)
--
TODO: 1 of 9 tasks shown
EOF

test_todo_session 'lswait for multiple-REASON' <<EOF
>>> todo.sh -p lswait for money "salary increase" 2,3
5 2011-01-01 build your dream home +house w:3 w:4
3 2012-02-01 buy the site +house w:1 w:2
2 2012-02-01 obtain a bank loan +house w:money w:(salary increase)
4 2012-02-02 hire an architect +house w:2 w:3
6 today +buy a color tv w:5 w:money
--
TODO: 5 of 9 tasks shown
EOF

test_todo_session 'lswait for both-REASON' <<EOF
>>> todo.sh -p lswait w:money "w:(salary increase)"
2 2012-02-01 obtain a bank loan +house w:money w:(salary increase)
--
TODO: 1 blocked of 9 tasks shown

>>> todo.sh -p lswait w:2 w:3
4 2012-02-02 hire an architect +house w:2 w:3
--
TODO: 1 blocked of 9 tasks shown
EOF

test_done
