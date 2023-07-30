Extensions for the TODO.TXT Command Line Interface
==================================================

The [Command Line Interface](https://github.com/todotxt/todo.txt-cli) of
the [Todo.txt](http://todotxt.org/) task tracking system allows extension via
add-ons (which supply customized or additional actions) and filters (which
influence the output of tasks).

Note from jcdietrich/todo.txt-cli-ex
==================================================
I have started to add to the work inkarkat has done.
Here is a list of what I have done:
 
  * new environment variables
    * `GNU_PREFIX="g"`
      * if this is set, it will add the value in front of the standard
        utils such as awk, grep, sed
      * this is useful if you are using a Mac and don't want to override the defaults
    * `TODO_NOTE_EDIT_OR_ADD=true`
      * if this has any value then:
        * trying to edit a note that doesn't already have one,
          will create one and then open it for editing
        * trying to add a note to one that already has one,
          will open it in the editor
    * `TODO_NOTE_TEMPLATE="<PATH/TO/TEMPLATE>"`
      * if set, adding a new note will append
        the contents of the template file to the
        newly created note after the title

  * new actions
    * `note` from Genzer/todo.txt-note 
      * this allows for essentially creating a linked text file to an item
    * `lsdonesince` created by me
      * allows you to pass in fuzzy date, and it will show only done tasks since that date 
    * `standup` created by me
      * probably not useful to other people
      * highly tied to my use of todo.txt and my workflow at work


Original note from inkarkat/todo.txt-cli-ex
==================================================
This is my personal set of extensions (some taken from other authors, but most
implemented by myself) that tailors Todo.txt for my own workflow.

If you find any of these useful, feel free to take them. All code is published
under the [GPL](https://www.gnu.org/copyleft/gpl.txt), like Todo.txt itself.
Discussions and questions around the Todo.txt workflow is best directed to the
[Todo.txt Gitter chat](https://gitter.im/todotxt/todo.txt-cli).



