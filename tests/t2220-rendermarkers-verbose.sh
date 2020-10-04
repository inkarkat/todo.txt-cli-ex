#!/bin/bash
#

test_description='rendermarkers verbose action

This test covers rendering synthesized (de-)prioritization and done via markers to the actual todo.txt symbols with verbose output.
'
. ./test-lib.sh

cat > todo.txt <<EOF
2009-02-01 simple task
x 2009-02-12 2009-02-01 prioritized A but already done A:2009-02-09
X 2009-02-12 2009-02-01 prioritized A but already trashed A:2009-02-09
2009-02-01 not yet prioritized A A:2009-02-22
2009-02-01 prioritized A A:2009-02-09
2009-02-01 prioritized X X:2009-02-09
2009-02-01 prioritized B out of three A:2009-02-22 B:2009-02-09 C:2009-02-08
2009-02-01 prioritized C because it is last A:2009-02-22 B:2009-02-09 D:2009-02-09 C:2009-02-09 E:2009-02-22
(B) 2009-02-01 override priority B with lower prioritized C C:2009-02-09
(D) 2009-02-01 override priority D with higher prioritized C C:2009-02-09
2009-02-01 invalid prioritized I task I:2009-02-0911
2009-02-01 first not yet prioritized A task A:2009-02-22 A:2009-02-09
2009-02-01 last not yet prioritized A task A:2009-02-09 A:2009-02-22
EOF

test_todo_session 'verbose rendering synthesized prioritization' <<EOF
>>> todo.sh rendermarkers 2009-02-13
[1;33m[7m12[1;33m (A) (12 days ago) first not yet prioritized A task A:(in 9 days)[0m
[1;33m[7m13[1;33m (A) (12 days ago) last not yet prioritized A task A:(in 9 days)[0m
[1;33m[7m05[1;33m (A) (12 days ago) prioritized A[0m
[0;32m[7m07[0;32m (B) (12 days ago) prioritized B out of three A:(in 9 days)[0m
[1;34m[7m09[1;34m (C) (12 days ago) override priority B with lower prioritized C[0m
[1;34m[7m10[1;34m (C) (12 days ago) override priority D with higher prioritized C[0m
[1;34m[7m08[1;34m (C) (12 days ago) prioritized C because it is last A:(in 9 days) E:(in 9 days)[0m
[1;37m[7m06[1;37m (X) (12 days ago) prioritized X[0m
EOF


cat > todo.txt <<EOF
2009-02-01 simple task
x (A) 2009-02-12 2009-02-01 depri of prioritized A but already done d:2009-02-09
X (A) 2009-02-12 2009-02-01 depri of prioritized A but already trashed d:2009-02-09
2009-02-01 depri of unprioritized task d:2009-02-09
(A) 2009-02-01 depri of prioritized A task d:2009-02-09
(A) 2009-02-01 not yet depri of prioritized A task d:2009-02-22
(Z) 2009-02-01 depri of prioritized Z task d:2009-02-09
2009-02-01 depri of synthetically prioritized C task C:2009-02-02 d:2009-02-09
2009-02-01 not yet depri of synthetically prioritized C task C:2009-02-02 d:2009-02-22
(I) 2009-02-01 invalid depri of prioritized I task d:2009-02-0911
(A) 2009-02-01 first not yet depri of prioritized A task d:2009-02-22 d:2009-02-09
(A) 2009-02-01 last not yet depri of prioritized A task d:2009-02-09 d:2009-02-22
EOF

test_todo_session 'verbose rendering synthesized deprioritization' <<EOF
>>> todo.sh rendermarkers 2009-02-13
[1;34m[7m09[1;34m (C) (12 days ago) not yet depri of synthetically prioritized C task d:(in 9 days)[0m
[7m05[0m (12 days ago) depri of prioritized A task
[0m[47m[7m07[0m[47m (12 days ago) depri of prioritized Z task[0m
[7m08[0m (12 days ago) depri of synthetically prioritized C task
[0m[47m[7m04[0m[47m (12 days ago) depri of unprioritized task[0m
[7m11[0m (12 days ago) first not yet depri of prioritized A task d:(in 9 days)
EOF


cat > todo.txt <<EOF
2009-02-01 simple task
x 2009-02-12 2009-02-01 trashed but already done x:2009-02-09
X 2009-02-12 2009-02-01 trashed and already trashed x:2009-02-09
2009-02-01 not yet trashed x:2009-02-22
2009-02-01 trashed x:2009-02-09
2009-02-01 invalid trashed x:2009-02-0911
2009-02-01 first not yet trashed x:2009-02-22 x:2009-02-09
2009-02-01 last not yet trashed x:2009-02-09 x:2009-02-22
EOF

test_todo_session 'verbose rendering synthesized trashing' <<EOF
>>> todo.sh rendermarkers 2009-02-13
[1;30m7 X (4 days ago, after 8 days) first not yet trashed x:(in 9 days)[0m
[1;30m5 X (4 days ago, after 8 days) trashed[0m
EOF


cat > todo.txt <<EOF
2009-02-01 simple task
x 2009-02-12 2009-02-01 do-until-then-trash but already done z:2009-02-09
X 2009-02-12 2009-02-01 do-until-then-trash and already trashed z:2009-02-09
2009-02-01 not yet do-until-then-trash z:2009-02-22
2009-02-01 do-until-then-trash z:2009-02-09
2009-02-01 do-until-then-trash on the until day z:2009-02-13
2009-02-01 do-until-then-trash one after the until day z:2009-02-12
2009-02-01 invalid do-until-then-trash z:2009-02-0911
2009-02-01 first not yet do-until-then-trash z:2009-02-22 z:2009-02-09
2009-02-01 last not yet do-until-then-trash z:2009-02-09 z:2009-02-22
EOF

test_todo_session 'verbose rendering synthesized do-until-then-trash' <<EOF
>>> todo.sh rendermarkers 2009-02-13
[1;30m05 X (4 days ago, after 8 days) do-until-then-trash[0m
[1;30m09 X (4 days ago, after 8 days) first not yet do-until-then-trash z:(in 9 days)[0m
[1;30m07 X (yesterday, after 11 days) do-until-then-trash one after the until day[0m
EOF

test_done
