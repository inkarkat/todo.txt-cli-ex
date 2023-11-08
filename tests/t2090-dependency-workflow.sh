#!/bin/bash
#

test_description='dependency workflow

This test covers the entire workflow around blocked tasks and dependencies.
'
. ./test-lib.sh

test_todo_session 'workflow' <<'EOF'
>>> todo.sh -p -x add find a building site
1 find a building site
TODO: 1 added.

>>> todo.sh -p -x add obtain a bank loan
2 obtain a bank loan
TODO: 2 added.

>>> todo.sh -p -x add buy the site
3 buy the site
TODO: 3 added.

>>> todo.sh -p -x wait 3 for 1,2
3 buy the site w:1 w:2
TODO: 3 has become dependent on 1, 2.

>>> todo.sh -p -x add hire an architect
4 hire an architect
TODO: 4 added.

>>> todo.sh -p -x wait 4 for 3
4 hire an architect w:3
TODO: 4 has become dependent on 3.

>>> todo.sh -p -x wait 2 money
2 obtain a bank loan w:money
TODO: 2 is blocked due to w:money.

>>> todo.sh -p -x add buy a color tv w:money
5 buy a color tv w:money
TODO: 5 added.

>>> todo.sh -p -x listblockers
money

>>> todo.sh -p -x command ls
5 buy a color tv w:money
3 buy the site w:1 w:2
1 find a building site
4 hire an architect w:3
2 obtain a bank loan w:money
--
TODO: 5 of 5 tasks shown

>>> todo.sh -p -x lswait
5 buy a color tv w:money
3 buy the site w:1 w:2
4 hire an architect w:3
2 obtain a bank loan w:money
--
TODO: 4 blocked of 5 tasks shown

>>> todo.sh -p -x blockerview
--- 1 find a building site ---
3 buy the site w:2
\
--- 2 obtain a bank loan w:money ---
3 buy the site w:1
\
--- 3 buy the site w:1 w:2 ---
4 hire an architect
\
--- money ---
5 buy a color tv
2 obtain a bank loan
\
--
TODO: 2 blocked task(s) waiting for 1 blocker(s).
TODO: 3 blocked task(s) waiting for 3 dependent task(s).

>>> todo.sh -p -x depview
4 hire an architect
  3 buy the site
    1 find a building site
    2 obtain a bank loan w:money
--
TODO: 1 block of 4 dependent tasks.

>>> todo.sh -p -x unwait money
2 obtain a bank loan
TODO: 2 unblocked.
5 buy a color tv
TODO: 5 unblocked.

>>> todo.sh -a -p -x do 1
1 x 2009-02-13 find a building site
TODO: 1 marked as done.
3 buy the site w:2
TODO: 3 had blocker(s) removed; still blocked.

>>> todo.sh -p -x unwait 3
3 buy the site
TODO: 3 unblocked.

>>> todo.sh -p -x lswait
4 hire an architect w:3
--
TODO: 1 blocked of 5 tasks shown

>>> todo.sh -p -x blockerview
--- 3 buy the site ---
4 hire an architect
\
--
TODO: 1 blocked task(s) waiting for 1 dependent task(s).

>>> TODOTXT_BACKUP_COMMAND=none todo.sh -p -x archive
1 x 2009-02-13 find a building site
--
TODO: 1 of 5 tasks archived
TODO: No tasks have been trashed.

>>> todo.sh -p -x blockerview
--- 2 buy the site ---
3 hire an architect
\
--
TODO: 1 blocked task(s) waiting for 1 dependent task(s).

>>> todo.sh -p -x unwait for 2
3 hire an architect
TODO: 3 unblocked.

>>> todo.sh -p -x lswait
--
TODO: 0 blocked of 4 tasks shown
EOF

test_done
