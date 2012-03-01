#!/bin/bash
#

test_description='relativeDates filter

This test covers the translation of YYYY-MM-DD dates into human-readable,
relative dates.
'
. ./test-lib.sh

# Prime the filter with the fixed test date and use it exclusively.
sed -i -e 's+^\(export TODOTXT_FINAL_FILTER=\).*$+\1"${TODO_FILTER_DIR}/relativeDates 2009-02-13"+' todo.cfg

cat > todo.txt <<EOF
2009-01-13 entered a month ago
2009-01-14 entered 31 days ago
2009-01-15 entered 30 days ago
2009-01-30 entered 15 days ago
2009-01-31 entered 14 days ago
2009-02-01 entered 13 days ago
2009-02-05 entered 8 days ago
2009-02-06 entered 7 days ago
2009-02-07 entered 6 days ago
2009-02-10 get a bank loan
2009-02-11 subscribe to pay-tv
2009-02-12 buy groceries
2009-02-13 mow the lawn +garden @outside
2009-02-14 plant a tree +garden
2009-02-15 watch tv @home
2009-02-19 in 6 days
2009-02-20 in 7 days
2009-02-21 in 8 days
2009-02-26 in 13 days
2009-02-27 in 14 days
2009-02-28 in 15 days
2009-03-13 in a month
2009-03-14 in 30 days
2009-03-15 in 31 days
EOF
test_todo_session 'relativeDates add date translation of plain tasks' <<EOF
>>> todo.sh -p ls
01 2009-01-13 entered a month ago
02 2009-01-14 entered 31 days ago
03 2009-01-15 entered 30 days ago
04 (two weeks ago) entered 15 days ago
05 (13 days ago) entered 14 days ago
06 (12 days ago) entered 13 days ago
07 (8 days ago) entered 8 days ago
08 (one week ago) entered 7 days ago
09 (6 days ago) entered 6 days ago
10 (3 days ago) get a bank loan
11 (2 days ago) subscribe to pay-tv
12 yesterday buy groceries
13 today mow the lawn +garden @outside
14 tomorrow plant a tree +garden
15 (in 2 days) watch tv @home
16 (in 6 days) in 6 days
17 (in one week) in 7 days
18 (in 8 days) in 8 days
19 (in 13 days) in 13 days
20 (in two weeks) in 14 days
21 2009-02-28 in 15 days
22 2009-03-13 in a month
23 2009-03-14 in 30 days
24 2009-03-15 in 31 days
--
TODO: 24 of 24 tasks shown
EOF

cat > todo.txt <<EOF
x 2009-02-10 get a bank loan
(B) 2009-02-13 mow the lawn +garden @outside
2009-02-14 plant a tree +garden
(C) 2009-02-15 watch tv @home
EOF
test_todo_session 'relativeDates add date translation of prioritized and done tasks' <<EOF
>>> todo.sh -p ls
2 (B) today mow the lawn +garden @outside
4 (C) (in 2 days) watch tv @home
3 tomorrow plant a tree +garden
1 x (3 days ago) get a bank loan
--
TODO: 4 of 4 tasks shown

>>> todo.sh ls
[0;32m2 (B) today mow the lawn +garden @outside[0m
[1;34m4 (C) (in 2 days) watch tv @home[0m
3 tomorrow plant a tree +garden
[0;37m1 x (3 days ago) get a bank loan[0m
--
TODO: 4 of 4 tasks shown
EOF

cat > todo.txt <<EOF
x 2009-02-10 get a bank loan for 2009-2010
(B) 2009-02-13 mow the lawn in Feb-2009 +garden m:2009-04-01 @outside
2009-02-14 plant a 02-13 tree +garden m:2009-02-12 n:2009-10-01
(C) 2009-02-15 watch F2009-02-12 tv on 2009-02-13 @home
check the log file 2009-02-12_15:00.12 for errors
EOF
test_todo_session 'relativeDates translation of date markers' <<EOF
>>> todo.sh -p ls
2 (B) today mow the lawn in Feb-2009 +garden m:2009-04-01 @outside
4 (C) (in 2 days) watch F2009-02-12 tv on today @home
3 tomorrow plant a 02-13 tree +garden m:yesterday n:2009-10-01
5 check the log file yesterday_15:00.12 for errors
1 x (3 days ago) get a bank loan for 2009-2010
--
TODO: 5 of 5 tasks shown
EOF

cat > todo.txt <<EOF
x 2009-02-13 2009-02-10 get a bank loan
x 2009-02-13 2009-02-13 mow the lawn +garden m:2009-04-01 @outside
x 2009-02-12 2009-02-11 plant a tree +garden
x 2009-02-12 2009-02-05 water the lawn +garden
x 2009-02-10 2009-01-12 watch tv @home
EOF
test_todo_session 'relativeDates done date translation' <<EOF
>>> todo.sh -p ls
5 x (3 days ago, after 29 days) watch tv @home
4 x (yesterday, after 7 days) water the lawn +garden
3 x (yesterday, from day before) plant a tree +garden
1 x (today, after 3 days) get a bank loan
2 x (today, from same day) mow the lawn +garden m:2009-04-01 @outside
--
TODO: 5 of 5 tasks shown
EOF

test_done
