#!/bin/bash
#

test_description='scheduledFilter filter

This test covers synthesized (de-)prioritization and done via markers.
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
EOF

test_todo_session 'synthesized prioritization' <<EOF
>>> todo.sh list prioritized
[1;33m[7m05[1;33m (A) (12 days ago) prioritized A A:(4 days ago)[0m
[0;32m[7m07[0;32m (B) (12 days ago) prioritized B out of three A:(in 9 days) B:(4 days ago) C:(5 days ago)[0m
[1;34m[7m09[1;34m (C) (12 days ago) override priority B with lower prioritized C C:(4 days ago)[0m
[1;34m[7m10[1;34m (C) (12 days ago) override priority D with higher prioritized C C:(4 days ago)[0m
[1;34m[7m08[1;34m (C) (12 days ago) prioritized C because it is last A:(in 9 days) B:(4 days ago) D:(4 days ago) C:(4 days ago) E:(in 9 days)[0m
[1;37m[7m06[1;37m (X) (12 days ago) prioritized X X:(4 days ago)[0m
[7m04[0m (12 days ago) not yet prioritized A A:(in 9 days)
[0;37m02 x (yesterday, after 11 days) prioritized A but already done A:(4 days ago)[0m
[1;30m03 X (yesterday, after 11 days) prioritized A but already trashed A:(4 days ago)[0m
--
TODO: 9 of 10 tasks shown
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
EOF

test_todo_session 'synthesized deprioritization' <<EOF
>>> todo.sh list depri
[1;33m[7m6[1;33m (A) (12 days ago) not yet depri of prioritized A task d:(in 9 days)[0m
[1;34m[7m9[1;34m (C) (12 days ago) not yet depri of synthetically prioritized C task C:(11 days ago) d:(in 9 days)[0m
[7m5[0m (12 days ago) depri of prioritized A task d:(4 days ago)
[0m[47m[7m7[0m[47m (12 days ago) depri of prioritized Z task d:(4 days ago)[0m
[7m8[0m (12 days ago) depri of synthetically prioritized C task C:(11 days ago) d:(4 days ago)
[0m[47m[7m4[0m[47m (12 days ago) depri of unprioritized task d:(4 days ago)[0m
[0;37m2 x (A) yesterday (12 days ago) depri of prioritized A but already done d:(4 days ago)[0m
[1;30m3 X (A) yesterday (12 days ago) depri of prioritized A but already trashed d:(4 days ago)[0m
--
TODO: 8 of 9 tasks shown
EOF


cat > todo.txt <<EOF
2009-02-01 simple task
x 2009-02-12 2009-02-01 trashed but already done x:2009-02-09
X 2009-02-12 2009-02-01 trashed and already trashed x:2009-02-09
2009-02-01 not yet trashed x:2009-02-22
2009-02-01 trashed x:2009-02-09
EOF

test_todo_session 'synthesized trashing' <<EOF
>>> todo.sh list trashed
[7m4[0m (12 days ago) not yet trashed x:(in 9 days)
[1;30m5 X (4 days ago, after 8 days) trashed x:(4 days ago)[0m
[1;30m3 X (yesterday, after 11 days) trashed and already trashed x:(4 days ago)[0m
[0;37m2 x (yesterday, after 11 days) trashed but already done x:(4 days ago)[0m
--
TODO: 4 of 5 tasks shown
EOF


cat > todo.txt <<EOF
2009-02-01 simple task
x 2009-02-12 2009-02-01 do-until-then-trash but already done z:2009-02-09
X 2009-02-12 2009-02-01 do-until-then-trash and already trashed z:2009-02-09
2009-02-01 not yet do-until-then-trash z:2009-02-22
2009-02-01 do-until-then-trash z:2009-02-09
2009-02-01 do-until-then-trash on the until day z:2009-02-13
2009-02-01 do-until-then-trash one after the until day z:2009-02-12
EOF

test_todo_session 'synthesized do-until-then-trash' <<EOF
>>> todo.sh list do-until-then-trash
[0m[48;5;202m[7m6[0m[48;5;202m (12 days ago) do-until-then-trash on the until day z:today[0m
[7m4[0m (12 days ago) not yet do-until-then-trash z:(in 9 days)
[1;30m5 X (4 days ago, after 8 days) do-until-then-trash z:(4 days ago)[0m
[1;30m3 X (yesterday, after 11 days) do-until-then-trash and already trashed z:(4 days ago)[0m
[0;37m2 x (yesterday, after 11 days) do-until-then-trash but already done z:(4 days ago)[0m
[1;30m7 X (yesterday, after 11 days) do-until-then-trash one after the until day z:yesterday[0m
--
TODO: 6 of 7 tasks shown
EOF

test_done
