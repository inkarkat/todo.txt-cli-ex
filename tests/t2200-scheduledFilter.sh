#!/usr/bin/env bash
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
2009-02-01 invalid prioritized I task I:2009-02-0911
2009-02-01 first not yet prioritized A task A:2009-02-22 A:2009-02-09
2009-02-01 last not yet prioritized A task A:2009-02-09 A:2009-02-22
EOF

test_todo_session 'synthesized prioritization' <<EOF
>>> todo.sh -p list prioritized
12 (A) (12 days ago) first not yet prioritized A task A:(in 9 days) A:(4 days ago)
13 (A) (12 days ago) last not yet prioritized A task A:(4 days ago) A:(in 9 days)
05 (A) (12 days ago) prioritized A A:(4 days ago)
07 (B) (12 days ago) prioritized B out of three A:(in 9 days) B:(4 days ago) C:(5 days ago)
09 (C) (12 days ago) override priority B with lower prioritized C C:(4 days ago)
10 (C) (12 days ago) override priority D with higher prioritized C C:(4 days ago)
08 (C) (12 days ago) prioritized C because it is last A:(in 9 days) B:(4 days ago) D:(4 days ago) C:(4 days ago) E:(in 9 days)
06 (X) (12 days ago) prioritized X X:(4 days ago)
11 (12 days ago) invalid prioritized I task I:2009-02-0911
04 (12 days ago) not yet prioritized A A:(in 9 days)
02 x (yesterday, after 11 days) prioritized A but already done A:(4 days ago)
03 X (yesterday, after 11 days) prioritized A but already trashed A:(4 days ago)
--
TODO: 12 of 13 tasks shown
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

test_todo_session 'synthesized deprioritization' <<EOF
>>> todo.sh -p list depri
12 (A) (12 days ago) last not yet depri of prioritized A task d:(4 days ago) d:(in 9 days)
06 (A) (12 days ago) not yet depri of prioritized A task d:(in 9 days)
09 (C) (12 days ago) not yet depri of synthetically prioritized C task C:(11 days ago) d:(in 9 days)
10 (I) (12 days ago) invalid depri of prioritized I task d:2009-02-0911
05 (12 days ago) depri of prioritized A task d:(4 days ago)
07 (12 days ago) depri of prioritized Z task d:(4 days ago)
08 (12 days ago) depri of synthetically prioritized C task C:(11 days ago) d:(4 days ago)
04 (12 days ago) depri of unprioritized task d:(4 days ago)
11 (12 days ago) first not yet depri of prioritized A task d:(in 9 days) d:(4 days ago)
02 x (A) yesterday (12 days ago) depri of prioritized A but already done d:(4 days ago)
03 X (A) yesterday (12 days ago) depri of prioritized A but already trashed d:(4 days ago)
--
TODO: 11 of 12 tasks shown
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

test_todo_session 'synthesized trashing' <<EOF
>>> todo.sh -p list trashed
6 (12 days ago) invalid trashed x:2009-02-0911
8 (12 days ago) last not yet trashed x:(4 days ago) x:(in 9 days)
4 (12 days ago) not yet trashed x:(in 9 days)
7 X (4 days ago, after 8 days) first not yet trashed x:(in 9 days) x:(4 days ago)
5 X (4 days ago, after 8 days) trashed x:(4 days ago)
3 X (yesterday, after 11 days) trashed and already trashed x:(4 days ago)
2 x (yesterday, after 11 days) trashed but already done x:(4 days ago)
--
TODO: 7 of 8 tasks shown
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

test_todo_session 'synthesized do-until-then-trash' <<EOF
>>> todo.sh -p list do-until-then-trash
06 (12 days ago) do-until-then-trash on the until day z:today
08 (12 days ago) invalid do-until-then-trash z:2009-02-0911
10 (12 days ago) last not yet do-until-then-trash z:(4 days ago) z:(in 9 days)
04 (12 days ago) not yet do-until-then-trash z:(in 9 days)
05 X (4 days ago, after 8 days) do-until-then-trash z:(4 days ago)
09 X (4 days ago, after 8 days) first not yet do-until-then-trash z:(in 9 days) z:(4 days ago)
03 X (yesterday, after 11 days) do-until-then-trash and already trashed z:(4 days ago)
02 x (yesterday, after 11 days) do-until-then-trash but already done z:(4 days ago)
07 X (yesterday, after 11 days) do-until-then-trash one after the until day z:yesterday
--
TODO: 9 of 10 tasks shown
EOF

test_done
