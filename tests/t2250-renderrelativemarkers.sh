#!/bin/bash
#

test_description='renderrelativemarkers action

This test covers rendering dates in markers into canonical form.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2009-02-01 a simple task
2009-02-01 already canonical marker m:2009-02-13
2009-02-01 date format marker m:14-Feb-2009
2009-02-01 duplicated m:14-Feb-2009 date format marker m:14-Feb-2009
2009-02-01 multiple a:12-Feb-2009 b:11-Feb-2009 date format markers c:14-Feb-2009
EOF

test_todo_session 'rendering dates in marker' <<EOF
>>> TODOTXT_VERBOSE=0 todo.sh renderrelativemarkers

>>> todo.sh -p -x list
1 2009-02-01 a simple task
2 2009-02-01 already canonical marker m:2009-02-13
3 2009-02-01 date format marker m:2009-02-14
4 2009-02-01 duplicated m:2009-02-14 date format marker m:2009-02-14
5 2009-02-01 multiple a:2009-02-12 b:2009-02-11 date format markers c:2009-02-14
--
TODO: 5 of 5 tasks shown
EOF


cat > todo.txt <<EOF
2009-02-01 a simple task
2009-02-01 already canonical task reference a:1
2009-02-01 task reference to previous task a:.-1
2009-02-01 task reference to previous tasks a:.-2 b:.-3 c:-1 d:.- e:.+
2009-02-01 task reference to following (non-existing) task a:.+1
EOF

test_todo_session 'rendering relative task references in markers' <<EOF
>>> TODOTXT_VERBOSE=0 todo.sh renderrelativemarkers

>>> todo.sh -p -x list
1 2009-02-01 a simple task
2 2009-02-01 already canonical task reference a:1
5 2009-02-01 task reference to following (non-existing) task a:6
3 2009-02-01 task reference to previous task a:2
4 2009-02-01 task reference to previous tasks a:2 b:1 c:-1 d:.- e:.+
--
TODO: 5 of 5 tasks shown
EOF


cat > todo.txt <<EOF
2009-02-01 a simple task
2009-02-01 date format non-marker seen:14-Feb-2009
2009-02-01 non-marker https://www.example.com/
2009-02-01 non-marker task reference file:.-1
EOF

test_todo_session 'non-markers are not rendered' <<EOF
>>> TODOTXT_VERBOSE=0 todo.sh renderrelativemarkers

>>> todo.sh -p -x list
1 2009-02-01 a simple task
2 2009-02-01 date format non-marker seen:14-Feb-2009
3 2009-02-01 non-marker https://www.example.com/
4 2009-02-01 non-marker task reference file:.-1
--
TODO: 4 of 4 tasks shown
EOF

test_done
