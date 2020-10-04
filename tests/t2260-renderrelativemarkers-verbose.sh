#!/bin/bash
#

test_description='renderrelativemarkers verbose action

This test covers rendering dates in markers into canonical form with verbose output.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2009-02-01 a simple task
2009-02-01 already canonical marker m:2009-02-13
2009-02-01 date format marker m:14-Feb-2009
2009-02-01 duplicated m:14-Feb-2009 date format marker m:14-Feb-2009
2009-02-01 multiple a:12-Feb-2009 b:11-Feb-2009 date format markers c:14-Feb-2009
EOF

test_todo_session 'verbose rendering dates in marker' <<EOF
>>> todo.sh -p -x renderrelativemarkers
3 2009-02-01 date format marker m:2009-02-14
4 2009-02-01 duplicated m:2009-02-14 date format marker m:2009-02-14
5 2009-02-01 multiple a:2009-02-12 b:2009-02-11 date format markers c:2009-02-14

>>> todo.sh -p -x list
1 2009-02-01 a simple task
2 2009-02-01 already canonical marker m:2009-02-13
3 2009-02-01 date format marker m:2009-02-14
4 2009-02-01 duplicated m:2009-02-14 date format marker m:2009-02-14
5 2009-02-01 multiple a:2009-02-12 b:2009-02-11 date format markers c:2009-02-14
--
TODO: 5 of 5 tasks shown
EOF

test_done
