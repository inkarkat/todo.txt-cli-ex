#!/usr/bin/env bash
#

test_description='dopart action

This test covers partially doing a task.
'
. ./test-lib.sh

test_todo_session 'do parts separated by comma' <<EOF
>>> todo.sh add +housing find a building site, obtain a bank loan, buy the site, hire an architect, build your dream home
1 +housing find a building site, obtain a bank loan, buy the site, hire an architect, build your dream home
TODO: 1 added.

>>> todo.sh dopart 1 2
1 +housing find a building site, (obtain a bank loan => 2009-02-13), buy the site, hire an architect, build your dream home
TODO: part of 1 marked as done: (obtain a bank loan => 2009-02-13)

>>> test_tick; todo.sh dopart 1 1 3
1 +housing (find a building site => 2009-02-14), (obtain a bank loan => 2009-02-13), buy the site, hire an architect, build your dream home
TODO: part of 1 marked as done: (find a building site => 2009-02-14)
1 +housing (find a building site => 2009-02-14), (obtain a bank loan => 2009-02-13), (buy the site => 2009-02-14), hire an architect, build your dream home
TODO: part of 1 marked as done: (buy the site => 2009-02-14)
EOF

test_todo_session 'do parts separated by and to completion' <<EOF
>>> todo.sh add +buy beer and tacos and the LOTR trilogy
2 +buy beer and tacos and the LOTR trilogy
TODO: 2 added.

>>> todo.sh dopart 2 3
2 +buy beer and tacos and (the LOTR trilogy => 2009-02-14)
TODO: part of 2 marked as done: (the LOTR trilogy => 2009-02-14)

>>> todo.sh -a dopart 2 1 2
2 +buy (beer and tacos => 2009-02-14) and (the LOTR trilogy => 2009-02-14)
TODO: part of 2 marked as done: (beer and tacos => 2009-02-14)
TODO: All parts are completely done now; marking entire task as done.
2 x 2009-02-14 +buy (beer and tacos => 2009-02-14) and (the LOTR trilogy => 2009-02-14)
TODO: 2 marked as done.
EOF

test_todo_session 'do parts separated by mixed' <<EOF
>>> todo.sh add '@home clean the sink and the table, do the dishes; mop the floor, vacuum the carpet and the sofa'
3 @home clean the sink and the table, do the dishes; mop the floor, vacuum the carpet and the sofa
TODO: 3 added.

>>> todo.sh dopart 3 1 2 4 6
3 @home (clean the sink and the table => 2009-02-14), do the dishes; mop the floor, vacuum the carpet and the sofa
TODO: part of 3 marked as done: (clean the sink and the table => 2009-02-14)
3 @home (clean the sink and the table => 2009-02-14), do the dishes; (mop the floor => 2009-02-14), vacuum the carpet and the sofa
TODO: part of 3 marked as done: (mop the floor => 2009-02-14)
3 @home (clean the sink and the table => 2009-02-14), do the dishes; (mop the floor => 2009-02-14), vacuum the carpet and (the sofa => 2009-02-14)
TODO: part of 3 marked as done: (the sofa => 2009-02-14)
EOF

test_todo_session 'do parts matching pattern' <<EOF
>>> todo.sh add '+buy fuel to make a @cross-country trip in order to watch the @starship launch'
4 +buy fuel to make a @cross-country trip in order to watch the @starship launch
TODO: 4 added.

>>> todo.sh dopart 4 'fuel'
4 +buy (fuel => 2009-02-14) to make a @cross-country trip in order to watch the @starship launch
TODO: part of 4 marked as done: (fuel => 2009-02-14)

>>> todo.sh dopart 4 'make .* trip'
4 +buy (fuel => 2009-02-14) to (make a @cross-country trip => 2009-02-14) in order to watch the @starship launch
TODO: part of 4 marked as done: (make a @cross-country trip => 2009-02-14)

>>> todo.sh dopart 4 'watch.*$'
4 +buy (fuel => 2009-02-14) to (make a @cross-country trip => 2009-02-14) in order to (watch the @starship launch => 2009-02-14)
TODO: part of 4 marked as done: (watch the @starship launch => 2009-02-14)
EOF

test_todo_session 'do parts pattern matching cornercases' <<EOF
>>> todo.sh add +buy +tryout night-vision camera for squirrel sightings @home @night
5 +buy +tryout night-vision camera for squirrel sightings @home @night
TODO: 5 added.

>>> todo.sh dopart 5 'bargain hunting'
=== 1
TODO: pattern "bargain hunting" does not match

>>> todo.sh dopart 5 '.*'
=== 1
TODO: pattern ".*" matches the entire task

>>> todo.sh dopart 5 +buy
5 (+buy => 2009-02-14) +tryout night-vision camera for squirrel sightings @home @night
TODO: part of 5 marked as done: (+buy => 2009-02-14)

>>> test_tick; todo.sh dopart 5 +tryout
5 (+buy => 2009-02-14) (+tryout => 2009-02-15) night-vision camera for squirrel sightings @home @night
TODO: part of 5 marked as done: (+tryout => 2009-02-15)

>>> todo.sh dopart 5 @home
5 (+buy => 2009-02-14) (+tryout => 2009-02-15) night-vision camera for squirrel sightings (@home => 2009-02-15) @night
TODO: part of 5 marked as done: (@home => 2009-02-15)

>>> test_tick; todo.sh dopart 5 @night
5 (+buy => 2009-02-14) (+tryout => 2009-02-15) night-vision camera for squirrel sightings (@home => 2009-02-15) (@night => 2009-02-16)
TODO: part of 5 marked as done: (@night => 2009-02-16)

>>> todo.sh -a dopart 5 'night.*sightings'
5 (+buy => 2009-02-14) (+tryout => 2009-02-15) (night-vision camera for squirrel sightings => 2009-02-16) (@home => 2009-02-15) (@night => 2009-02-16)
TODO: part of 5 marked as done: (night-vision camera for squirrel sightings => 2009-02-16)
TODO: All parts are completely done now; marking entire task as done.
5 x 2009-02-16 (+buy => 2009-02-14) (+tryout => 2009-02-15) (night-vision camera for squirrel sightings => 2009-02-16) (@home => 2009-02-15) (@night => 2009-02-16)
TODO: 5 marked as done.
EOF

test_done
