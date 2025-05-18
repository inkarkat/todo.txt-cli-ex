#!/usr/bin/env bash
#

test_description='dopart action

This test covers doing with a comment.
'
. ./test-lib.sh

cat > todo.txt <<EOF
remember milk or tea
+housing (find a building site => 2009-02-14), (obtain a bank loan, buy the site => 2009-02-13), hire an architect, build your dream home
+buy something simple and something expensive and something red
EOF

test_todo_session 'do numbered parts with comment' <<EOF
>>> todo.sh dopart 3 1 2 'water / whiskey'
3 +buy (something simple and something expensive => 2009-02-13 water / whiskey) and something red
TODO: part of 3 marked as done: (something simple and something expensive => 2009-02-13 water / whiskey)

>>> todo.sh -a dopart 3 3 'a Ferrari'
3 +buy (something simple and something expensive => 2009-02-13 water / whiskey) and (something red => 2009-02-13 a Ferrari)
TODO: part of 3 marked as done: (something red => 2009-02-13 a Ferrari)
TODO: All parts are completely done now; marking entire task as done.
3 x 2009-02-13 +buy (something simple and something expensive => 2009-02-13 water / whiskey) and (something red => 2009-02-13 a Ferrari)
TODO: 3 marked as done.
EOF

test_todo_session 'do matched part with comment' <<EOF
>>> todo.sh dopart 1 milk "full-fat only"
1 remember (milk => 2009-02-13 full-fat only) or tea
TODO: part of 1 marked as done: (milk => 2009-02-13 full-fat only)
EOF

test_done
