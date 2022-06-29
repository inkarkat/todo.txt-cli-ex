#!/bin/bash
#

test_description='dopart action

This test covers listing parts.
'
. ./test-lib.sh

cat > todo.txt <<EOF
+housing (find a building site => 2009-02-14), (obtain a bank loan => 2009-02-13), buy the site, hire an architect, build your dream home
+buy (beer and tacos => 2009-02-14) and (the LOTR trilogy => 2009-02-14)
@home clean the sink and the table, do the dishes; mop the floor, vacuum the carpet and the sofa
EOF

test_todo_session 'list parts separated by mixed separators' <<EOF
>>> todo.sh dopart 3
TODO: Available parts:
1 clean the sink
2 the table
3 do the dishes
4 mop the floor
5 vacuum the carpet
6 the sofa
EOF

test_todo_session 'list parts already done' <<EOF
>>> todo.sh dopart 2
TODO: Available parts:
1 (beer
2 tacos => 2009-02-14)
3 (the LOTR trilogy => 2009-02-14)
EOF

test_todo_session 'list parts partially done' <<EOF
>>> todo.sh dopart 1
TODO: Available parts:
1 (find a building site => 2009-02-14)
2 (obtain a bank loan => 2009-02-13)
3 buy the site
4 hire an architect
5 build your dream home
EOF

test_done
