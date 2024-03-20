#!/usr/bin/env python
# pylint: disable=global-statement,invalid-name,missing-function-docstring

""" TODO.TXT Bird's Eye View Reporter
USAGE NOTES:
    Works on the raw text files referenced by $TODO_FILE and $DONE_FILE.
    See more on todo.txt here: http://todotxt.com

OUTPUT:
    Displays a list of:
    - working projects and their percentage complete
    - contexts in which open todo's exist
    - contexts and projects with tasks that have been prioritized
    - projects which are completely done (don't have any open todo's)
"""


import math
import os
import re
import sys

__author__ = "Gina Trapani (ginatrapani@gmail.com)"
__copyright__ = "Copyright 2006-2024, Gina Trapani"
__license__ = "GPL"


def printTaskGroups(title, taskDict, taskPriorities, taskCompletionPercentages, taskNum):
    print("")
    print(title)
    if not taskDict:
        print('No items to list.')
        return

    itemMaxLength = len(max(taskDict, key=len))

    # Sort first by number of tasks descending, then by case-insensitive item name.
    items = sorted(list(taskDict.items()), key=lambda x: (-1 * x[1], x[0].casefold()))

    separator('-', (33 if items[0][0] in taskCompletionPercentages else 15) + itemMaxLength)

    priorityItems, nonPriorityItems = [], []
    for item in items:
        (priorityItems if item[0] in taskPriorities.keys() else nonPriorityItems).append(item)

    def printItemTaskGroup(item, star):
        printTaskGroup(item, itemMaxLength, taskCompletionPercentages.get(item[0], -1), star, taskNum)

    for item in priorityItems:
        printItemTaskGroup(item, renderPriorities(taskPriorities[item[0]]))
    for item in nonPriorityItems:
        printItemTaskGroup(item, "    ")

def renderPriorities(priorities):
    sortedPriorities = sorted(priorities)
    if len(sortedPriorities) <= 4:  # There's enough space to show all priorities.
        return f'{"".join(sortedPriorities):4s}'
    return f'{sortedPriorities[0]}..{sortedPriorities[-1]}' # Just show the first and last priority.

def printTaskGroup(p, pMaxLen, pctage, star, taskNum):
    taskWidth = int(math.ceil(math.log(taskNum, 10)))
    taskPlural = " " if p[1] == 1 else "s"
    pctageWidget = ''
    if pctage > -1:
        progressBar = "=" * int(pctage // 10)
        pctageWidget = f' {pctage:3d}% [{progressBar:10s}]'

    print(f'{star}{pctageWidget} {p[0]:{pMaxLen}s} ({p[1]:{taskWidth}d} task{taskPlural})')


SEP_WIDTH = 0


def separator(c, width):
    global SEP_WIDTH
    SEP_WIDTH = max(width, SEP_WIDTH)
    print(c * SEP_WIDTH)


PRIORITY_PATTERN = re.compile(r'\(([A-Z])\)')
def process(filespec, sigil, openTaskCounts, doneTaskCounts, taskPriorities):
    with open(filespec, "r") as f:
        taskCnt = 0
        for line in f:
            priority = None
            words = line.split()
            if not words:
                continue
            if words[0] == "X":
                continue    # Ignore trashed tasks.

            taskCnt += 1
            if priorityMatch := PRIORITY_PATTERN.fullmatch(words[0]):
                priority = priorityMatch.group(1)

            if words[0] == ("x"):
                for word in words:
                    wordWithSigil = getWordWithSigil(word, sigil)
                    if wordWithSigil:
                        doneTaskCounts[wordWithSigil] = doneTaskCounts.setdefault(wordWithSigil, 0) + 1
            else:
                for word in words:
                    wordWithSigil = getWordWithSigil(word, sigil)
                    if wordWithSigil:
                        openTaskCounts[wordWithSigil] = openTaskCounts.setdefault(wordWithSigil, 0) + 1
                        if priority:
                            taskPriorities.setdefault(wordWithSigil, set()).add(priority)
        return taskCnt


if (os.environ['TODOTXT_SIGIL_BEFORE_PATTERN']
        or os.environ['TODOTXT_SIGIL_VALID_PATTERN'] != '.*'
        or os.environ['TODOTXT_SIGIL_AFTER_PATTERN']):

    def bre_to_pcre(bre_pattern):
        pcre_pattern = bre_pattern
        pcre_pattern = re.sub(r'\\([][(){}+?.*])', r'\1', pcre_pattern)
        pcre_pattern = re.sub(r'\\([<>])', r'\b', pcre_pattern)
        return pcre_pattern

    PATTERNS = []
    if os.environ['TODOTXT_SIGIL_BEFORE_PATTERN']:
        BEFORE_PATTERN = re.compile('^' + bre_to_pcre(os.environ['TODOTXT_SIGIL_BEFORE_PATTERN']))
        PATTERNS.append(lambda word, _: BEFORE_PATTERN.sub('', word))
    if os.environ['TODOTXT_SIGIL_AFTER_PATTERN']:
        AFTER_PATTERN = re.compile(bre_to_pcre(os.environ['TODOTXT_SIGIL_AFTER_PATTERN']) + '$')
        PATTERNS.append(lambda word, _: AFTER_PATTERN.sub('', word))
    if os.environ['TODOTXT_SIGIL_VALID_PATTERN']:
        def extractValid(word, sigil):
            match = re.match(re.escape(sigil) + bre_to_pcre(os.environ['TODOTXT_SIGIL_VALID_PATTERN']) + '$', word)
            if match:
                return match.group(0)
            return None
        PATTERNS.append(extractValid)

    def getWordWithSigil(word, sigil):
        for pattern in PATTERNS:
            word = pattern(word, sigil)
        return word
else:
    def getWordWithSigil(word, sigil):
        return word if word[0:1] == sigil and len(word) > 1 else None


def gather(sigil, openTaskCounts, doneTaskCounts, taskPriorities):
    taskNum = process(os.environ['TODO_FILE'], sigil, openTaskCounts, doneTaskCounts, taskPriorities)
    doneNum = process(os.environ['DONE_FILE'], sigil, doneTaskCounts, doneTaskCounts, taskPriorities)
    return taskNum, doneNum


def run(sigil, sigilDescription, isPrintOpen, isPrintCompleted):
    openTaskCounts = {}
    doneTaskCounts = {}
    taskPriorities = {}
    taskNum, doneNum = gather(sigil, openTaskCounts, doneTaskCounts, taskPriorities)

    if isPrintOpen:
        taskCompletionPercentages = {}
        for task in openTaskCounts:
            openTaskNum = openTaskCounts[task]
            doneTaskNum = doneTaskCounts.get(task, 0)
            totalTaskNum = openTaskNum + doneTaskNum
            taskCompletionPercentages[task] = int((doneTaskNum * 100) / totalTaskNum)

        printTaskGroups(f"{sigilDescription} with open tasks", openTaskCounts, taskPriorities, taskCompletionPercentages, taskNum)

    if isPrintCompleted:
        tasksWithNoneOpen = {}
        for task in doneTaskCounts:
            if task not in openTaskCounts:
                tasksWithNoneOpen[task] = doneTaskCounts[task]

        printTaskGroups(f'completed {sigilDescription} (all done, no open tasks)', tasksWithNoneOpen, {}, {}, taskNum + doneNum)


def main(argv):
    if len(argv) == 0:
        argv += ['all-projects', 'open-contexts']

    try:
        for arg in argv:
            isPrintOpen = False
            isPrintCompleted = False

            selector, axis = arg.split('-')
            if selector == 'open':
                isPrintOpen = True
            elif selector == 'completed':
                isPrintCompleted = True
            elif selector == 'all':
                isPrintOpen = isPrintCompleted = True
            else:
                raise ValueError("Invalid selector: " + selector)

            if axis == 'projects':
                run('+', axis, isPrintOpen, isPrintCompleted)
            elif axis == 'contexts':
                run('@', axis, isPrintOpen, isPrintCompleted)
            else:
                raise ValueError("Invalid axis: " + axis)
    except ValueError as e:
        print(e, file=sys.stderr)
        sys.exit(2)
    except Exception as e:  # pylint: disable=broad-except
        print(e, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main(sys.argv[1:])
