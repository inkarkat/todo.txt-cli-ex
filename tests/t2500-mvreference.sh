#!/usr/bin/env bash
#

test_description='mvreference action

This test covers the change of cross-task references.
'
. ./test-lib.sh

setup()
{
    cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-02 obtain a bank loan +house w:money
2012-02-03 hire an architect +house w:2 w:3
2012-03-01 build your dream home +house w:4
2012-03-18 buy new walking shoes


2012-03-18 go jogging w:10
EOF
}

setup
test_todo_session 'mvreference no changes because OLDNR does not exist' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house w:money
3 2012-02-03 hire an architect +house w:2 w:3
4 2012-03-01 build your dream home +house w:4
5 2012-03-18 buy new walking shoes
8 2012-03-18 go jogging w:10
--
TODO: 6 of 6 tasks shown

>>> todo.sh mvreference 5 42

>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house w:money
3 2012-02-03 hire an architect +house w:2 w:3
4 2012-03-01 build your dream home +house w:4
5 2012-03-18 buy new walking shoes
8 2012-03-18 go jogging w:10
--
TODO: 6 of 6 tasks shown
EOF

setup
test_todo_session 'mvreference adapts OLDNR to NEWNR' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house w:money
3 2012-02-03 hire an architect +house w:2 w:3
4 2012-03-01 build your dream home +house w:4
5 2012-03-18 buy new walking shoes
8 2012-03-18 go jogging w:10
--
TODO: 6 of 6 tasks shown

>>> todo.sh mvreference 3 10

>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house w:money
3 2012-02-03 hire an architect +house w:2 w:10
4 2012-03-01 build your dream home +house w:4
5 2012-03-18 buy new walking shoes
8 2012-03-18 go jogging w:10
--
TODO: 6 of 6 tasks shown
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-02 obtain a bank loan +house m:6
2012-02-03 buy the site +house marker:6 M:6 :6 m:6a m:-6
2012-02-03 hire an architect +house !:6 *:6
EOF
test_todo_session 'mvreference marker syntax' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house m:6
3 2012-02-03 buy the site +house marker:6 M:6 :6 m:6a m:-6
4 2012-02-03 hire an architect +house !:6 *:6
--
TODO: 4 of 4 tasks shown

>>> todo.sh mvreference 6 77

>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house m:77
3 2012-02-03 buy the site +house marker:6 M:77 :6 m:6a m:-6
4 2012-02-03 hire an architect +house !:77 *:77
--
TODO: 4 of 4 tasks shown
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house
2012-02-02 obtain a bank loan +house m:6
2012-02-03 buy the site +house marker:6 M:6 :6 m:6a m:-6
2012-02-03 hire an architect +house !:6 *:6
EOF
test_todo_session 'mvreference change marker syntax' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house m:6
3 2012-02-03 buy the site +house marker:6 M:6 :6 m:6a m:-6
4 2012-02-03 hire an architect +house !:6 *:6
--
TODO: 4 of 4 tasks shown

>>> TODOTXT_TASK_MARKER_PATTERN='^[[:lower:]]+:[0-9]+$' todo.sh mvreference 6 77

>>> todo.sh -p command ls
1 2011-01-01 find a building site +house
2 2012-02-02 obtain a bank loan +house m:77
3 2012-02-03 buy the site +house marker:77 M:6 :6 m:6a m:-6
4 2012-02-03 hire an architect +house !:6 *:6
--
TODO: 4 of 4 tasks shown
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house is no easy task to do
2012-02-02 obtain a bank loan +house after task 6
2012-02-03 buy the site +house w:6 after task 6
2012-02-03 hire an architect after task 6 and task 7
EOF
test_todo_session 'mvreference reference syntax' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site +house is no easy task to do
2 2012-02-02 obtain a bank loan +house after task 6
3 2012-02-03 buy the site +house w:6 after task 6
4 2012-02-03 hire an architect after task 6 and task 7
--
TODO: 4 of 4 tasks shown

>>> todo.sh mvreference 6 77

>>> todo.sh -p command ls
1 2011-01-01 find a building site +house is no easy task to do
2 2012-02-02 obtain a bank loan +house after task 77
3 2012-02-03 buy the site +house w:77 after task 77
4 2012-02-03 hire an architect after task 77 and task 7
--
TODO: 4 of 4 tasks shown
EOF

cat > todo.txt <<EOF
2011-01-01 find a building site +house is no easy task to do
2012-02-02 obtain a bank loan +house after thing 2
2012-02-03 buy the site +house w:2 after thing 2
2012-02-03 hire an architect after item 2 and thing 3
EOF
test_todo_session 'mvreference change reference syntax' <<EOF
>>> todo.sh -p command ls
1 2011-01-01 find a building site +house is no easy task to do
2 2012-02-02 obtain a bank loan +house after thing 2
3 2012-02-03 buy the site +house w:2 after thing 2
4 2012-02-03 hire an architect after item 2 and thing 3
--
TODO: 4 of 4 tasks shown

>>> TODOTXT_TASK_REFERENCE_PATTERN='^(item|thing)$' todo.sh mvreference 2 8

>>> todo.sh -p command ls
1 2011-01-01 find a building site +house is no easy task to do
2 2012-02-02 obtain a bank loan +house after thing 8
3 2012-02-03 buy the site +house w:8 after thing 8
4 2012-02-03 hire an architect after item 8 and thing 3
--
TODO: 4 of 4 tasks shown
EOF

test_done
