#!/bin/bash
#

test_description='wait action

This test covers the creation of blocked tasks.
'
. ./test-lib.sh

set_up()
{
    cat > todo.txt <<EOF
2011-01-01 find a building site
2012-02-01 obtain a bank loan
2012-02-02 buy the site
2012-02-03 hire an architect
2012-03-01 build your dream home
EOF
}

set_up
test_todo_session 'wait for REASON' <<EOF
>>> todo.sh -p wait 2 money
2 2012-02-01 obtain a bank loan w:money
TODO: 2 is blocked due to w:money.

>>> todo.sh -p wait 2 "salary increase"
2 2012-02-01 obtain a bank loan w:money w:(salary increase)
TODO: 2 is blocked due to w:(salary increase).

>>> todo.sh -p command ls
1 2011-01-01 find a building site
2 2012-02-01 obtain a bank loan w:money w:(salary increase)
3 2012-02-02 buy the site
4 2012-02-03 hire an architect
5 2012-03-01 build your dream home
--
TODO: 5 of 5 tasks shown
EOF

set_up
test_todo_session 'wait-multiple for REASON' <<EOF
>>> todo.sh -p wait 1,3 wife
1 2011-01-01 find a building site w:wife
TODO: 1 is blocked due to w:wife.
3 2012-02-02 buy the site w:wife
TODO: 3 is blocked due to w:wife.
EOF

set_up
test_todo_session 'wait for DEPNR' <<EOF
>>> todo.sh -p wait 3 for 2
3 2012-02-02 buy the site w:2
TODO: 3 has become dependent on 2.

>>> todo.sh -p command ls
1 2011-01-01 find a building site
2 2012-02-01 obtain a bank loan
3 2012-02-02 buy the site w:2
4 2012-02-03 hire an architect
5 2012-03-01 build your dream home
--
TODO: 5 of 5 tasks shown
EOF

set_up
test_todo_session 'wait for multiple DEPNR' <<EOF
>>> todo.sh -p wait 5 for 2 3,4
5 2012-03-01 build your dream home w:2 w:3 w:4
TODO: 5 has become dependent on 2, 3, 4.
EOF

set_up
test_todo_session 'wait for additional DEPNR' <<EOF
>>> todo.sh -p wait 5 for 2
5 2012-03-01 build your dream home w:2
TODO: 5 has become dependent on 2.

>>> todo.sh -p wait 5 for 3
5 2012-03-01 build your dream home w:2 w:3
TODO: 5 has become dependent on 3.
EOF

test_done
