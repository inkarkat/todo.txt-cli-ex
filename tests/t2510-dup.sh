#!/usr/bin/env bash
#

test_description='dup action

This test covers marking tasks as duplicates of other tasks.
'
. ./test-lib.sh

setup()
{
    cat > todo.txt <<EOF
2011-01-01 find a building site a:5 +house
2012-02-02 obtain a bank loan +house w:money k:5
2012-02-03 hire an architect +house w:1 w:2
2012-03-01 build your dream home +house w:3 k:6
2012-03-18 buy new walking shoes
2012-03-18 go jogging
2012-03-19 clean up repair shop
2012-03-20 enroll in swimming lessons
2012-03-21 fix old running shoes
EOF
}

setup
test_todo_session 'delete duplicate task' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup 6 del 9
9 2012-03-21 fix old running shoes => dup of 6
TODO: 9 deleted.
EOF

setup
test_todo_session 'delete two duplicate tasks' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup 6 del 7 9
7 2012-03-19 clean up repair shop => dup of 6
TODO: 7 deleted.
9 2012-03-21 fix old running shoes => dup of 6
TODO: 9 deleted.
EOF

setup
test_todo_session 'delete duplicate task that is referenced' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup 9 del 6
6 2012-03-18 go jogging => dup of 9
TODO: 6 deleted.

>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 8 of 8 tasks shown
EOF

setup
test_todo_session 'trash duplicate task' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup 6 trash 9
9 X 2009-02-13 2012-03-21 fix old running shoes => dup of 6
TODO: 9 trashed.
EOF

setup
test_todo_session 'trash duplicate task that is referenced' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup 9 trash 6
6 X 2009-02-13 2012-03-18 go jogging => dup of 9
TODO: 6 trashed.

>>> todo.sh -p -x command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
6 X 2009-02-13 2012-03-18 go jogging => dup of 9
--
TODO: 9 of 9 tasks shown
EOF

setup
test_todo_session 'immediate (hard) trash duplicate task' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup 6 trash --hard 9
1 X 2009-02-13 2012-03-21 fix old running shoes => dup of 6
TODO: 9 put into TRASH as 1.
EOF

setup
test_todo_session 'bidirectionally join two tasks' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup goal fitness 6 8
6 2012-03-18 go jogging j:fitness
8 2012-03-20 enroll in swimming lessons j:fitness
TODO: 6,8 now share the goal fitness
EOF

setup
test_todo_session 'bidirectionally cross-link two tasks' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup link 6 8
6 2012-03-18 go jogging l:8
TODO: 6 is linked to 8
8 2012-03-20 enroll in swimming lessons l:6
TODO: 8 is linked to 6
EOF

setup
test_todo_session 'bidirectionally cross-link three tasks' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site a:5 +house
2 2012-02-02 obtain a bank loan +house w:money k:5
3 2012-02-03 hire an architect +house w:1 w:2
4 2012-03-01 build your dream home +house w:3 k:6
5 2012-03-18 buy new walking shoes
6 2012-03-18 go jogging
7 2012-03-19 clean up repair shop
8 2012-03-20 enroll in swimming lessons
9 2012-03-21 fix old running shoes
--
TODO: 9 of 9 tasks shown

>>> todo.sh -a -f dup link 6 8 4
6 2012-03-18 go jogging l:8 l:4
TODO: 6 is linked to 8, 4
8 2012-03-20 enroll in swimming lessons l:6 l:4
TODO: 8 is linked to 6, 4
4 2012-03-01 build your dream home +house w:3 k:6 l:6 l:8
TODO: 4 is linked to 6, 8
EOF

test_done
