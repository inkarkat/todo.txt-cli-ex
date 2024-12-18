# Extensions for the TODO.TXT Command Line Interface

_A set of extensions for todo.txt-cli, a shell script for managing your todo.txt file._

The [Command Line Interface](https://github.com/todotxt/todo.txt-cli) of
the [Todo.txt](http://todotxt.org/) task tracking system allows extension via
**add-ons** (which supply customized or additional actions) and **filters** (which
influence the output of tasks).

This is my personal set of extensions (some taken from other authors, but most
implemented by myself) that tailors Todo.txt for my own workflow.

If you find any of these useful, feel free to take them. All code is published
under the [GPL](https://www.gnu.org/copyleft/gpl.txt), like Todo.txt itself.
Discussions and questions around the Todo.txt workflow is best directed to the
[todo.txt-cli GitHub discussions](https://github.com/todotxt/todo.txt-cli/discussions).

### Dependencies

* Bash, GNU `awk`, GNU `sed`
* [todo.txt-cli](https://github.com/inkarkat/todo.txt-cli) (official distribution or my fork)

### Installation

Place (e.g. via symlink) the actions into `TODO_ACTIONS_DIR` (`$HOME/.todo.actions.d`); cp. [Installing Add-ons](https://github.com/todotxt/todo.txt-cli/wiki/Creating-and-Installing-Add-ons#installing-add-ons)

Filter scripts are activated by adding them to `TODOTXT_FINAL_FILTER` (colorization and relative dates) / `pre_filter_command` (content filtering) in your `todo.cfg` file. For example:
```
export TODO_FILTER_DIR="$HOME/.todo/filter"
export TODOTXT_FINAL_FILTER="${TODO_FILTER_DIR:?}/colorFutureTasks | ${TODO_FILTER_DIR}/colorBlockedTasks | ${TODO_FILTER_DIR}/colorSymbols | ${TODO_FILTER_DIR}/relativeDates"
export pre_filter_command="${TODO_FILTER_DIR:?}/markerTrashedFilter | ${TODO_FILTER_DIR}/scheduledFilter"
```
