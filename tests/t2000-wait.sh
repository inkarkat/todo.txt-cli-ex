#!/bin/bash
#

test_description='wait action

This test covers the creation of blocked tasks.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2011-01-01 find a building site
2012-02-01 obtain a bank loan
2012-02-01 buy the site
2012-02-02 hire an architect
2011-01-01 build your dream home
EOF

test_todo_session 'wait for REASON' <<EOF
>>> todo.sh -p wait 2 money
2 2012-02-01 obtain a bank loan w:money
TODO: 2 is blocked due to w:money.

>>> todo.sh -p wait 2 "salary increase"
2 2012-02-01 obtain a bank loan w:money w:(salary increase)
TODO: 2 is blocked due to w:(salary increase).
EOF

test_todo_session 'wait-multiple for REASON' <<EOF
>>> todo.sh -p wait 1,3 wife
1 2011-01-01 find a building site w:wife
TODO: 1 is blocked due to w:wife.
3 2012-02-01 buy the site w:wife
TODO: 3 is blocked due to w:wife.
EOF

test_todo_session 'wait for DEPITEM#' <<EOF
>>> todo.sh -p wait 3 for 2
3 2012-02-01 buy the site w:wife w:2
TODO: 3 has become dependent on 2.
EOF

test_todo_session 'wait for multiple DEPITEM#' <<EOF
>>> todo.sh -p wait 5 for 2 3,4
5 2011-01-01 build your dream home w:2 w:3 w:4
TODO: 5 has become dependent on 2, 3, 4.
EOF

test_todo_session 'wait for additional DEPITEM#' <<EOF
>>> todo.sh -p add "get a building permit"
6 get a building permit
TODO: 6 added.

>>> todo.sh -p wait 5 for 6
5 2011-01-01 build your dream home w:2 w:3 w:4 w:6
TODO: 5 has become dependent on 6.
EOF

test_done
