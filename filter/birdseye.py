#!/usr/bin/python

""" TODO.TXT Bird's Eye View Reporter
USAGE:  
	birdseye.py [todo.txt] [done.txt]
	
USAGE NOTES:
	Expects two text files as parameters, each of which formatted as follows:
	- One todo per line, ie, "call Mom"
	- with an optional project association indicated as such: "+projectname"
	- with the context in which the tasks should be completed, indicated as such: "@context"
	- with the task priority optionally listed at the front of the line, in parens, ie, "(A)"
	
	For example, 4 lines of todo.txt might look like this:

	+garagesale @phone schedule Goodwill pickup
	(A) @phone Tell Mom I love her
	+writing draft Great American Novel
	(B) smell the roses
	
	The done.txt file is a list of completed todo's from todo.txt.
	
	See more on todo.txt here:
	http://todotxt.com
	
	
OUTPUT:
	Displays a list of:
	- working projects and their percentage complete
	- contexts in which open todo's exist
	- contexts and projects with tasks that have been prioritized
	- projects which are completely done (don't have any open todo's)

CHANGELOG:
	2006.07.29 - Now supports p:, p- and + project notation.  Tx, Pedro!
	2006.05.02 - Released
"""


import math, sys, os
#import datetime

__version__ = "1.1"
__date__ = "2006/05/02"
__updated__ = "2006/07/29"
__author__ = "Gina Trapani (ginatrapani@gmail.com)"
__copyright__ = "Copyright 2006, Gina Trapani"
__license__ = "GPL"
__history__ = """
1.0 - Released.
"""

def usage():
	print "USAGE:  %s [(open|closed|all)-(project|context) [...]] todo.txt done.txt"% (sys.argv[0], )

def printTaskGroups(title, taskDict, priorityList, percentages):
	print ""	
	print "%s"% (title,)
	if not taskDict:
		print "No items to list."
	else:
		itemMaxLength = len(max(taskDict, key=len))
		separator("-", 33 + itemMaxLength)

		# sort the dictionary by value
		# http://python.fyxm.net/peps/pep-0265.html
		items = [(v, k) for k, v in taskDict.items()]
		items.sort()
		items.reverse()             # so largest is first
		items = [(k, v) for v, k in items]

		for item in items:	
			if item[0] in priorityList:
				if item[0] not in percentages:
					printTaskGroup(item, itemMaxLength, -1, "*")
				else:
					printTaskGroup(item, itemMaxLength, percentages[item[0]], "*")

		for item in items:
			if item[0] not in priorityList:
				if item[0] not in percentages:
					printTaskGroup(item, itemMaxLength, -1, " ")
				else:
					printTaskGroup(item, itemMaxLength, percentages[item[0]], " ")
			
def printTaskGroup(p, pMaxLen, pctage, star):
	if pctage > -1:
		progressBar = ""
		numStars = (pctage/10)
		progressBar = "=" * numStars
		numSpaces = 10 - numStars
		for n in range(numSpaces):
			progressBar += " "	

		if pctage > 9:	
			displayTotal = " %d%%"% (pctage, );
		else:
			displayTotal = "  %d%%"% (pctage, );
		print "%s %s [%s] %*s (%*d task%s)"% (star, displayTotal, progressBar, (-1 * pMaxLen), p[0], taskWidth, p[1], (" " if p[1] == 1 else "s"), )
	else:
		print "%s %*s (%*d task%s)"% (star, (-1 * pMaxLen), p[0], taskWidth, p[1], (" " if p[1] == 1 else "s"), )
	
global sepWidth
sepWidth = 0
def separator(c, width):
	global sepWidth
	sepWidth = width if sepWidth == 0 else sepWidth
	sep = ""
	sep = c * sepWidth
	print sep


def process(filespec, prefix, tasks, completed, priority):
	try:
		f = open (filespec, "r")
		taskNum = 0
		for line in f:
			taskNum += 1
			prioritized = False
			words = line.split()
			if words[0][0:1] == ("("):
				prioritized = True
			if words[0] == ("x"):
				for word in words:
					if word[0:1] == prefix:
						if word not in completed:
							completed[word] = 1
						else:
							completed[word] = completed.setdefault(word, 0) + 1
			else:
				for word in words:
					if word[0:1] == prefix:
						if word not in tasks:
							tasks[word] = 1
						else:
							tasks[word] = tasks.setdefault(word,0)  + 1
						if prioritized:
							priority.append(word)
		f.close()
		return taskNum
	except IOError:
		print "ERROR:  The file named %s could not be read."% (filespec, )
		usage()
		sys.exit(2)

def gather(prefix, tasks, completed, priority):
	global taskNum
	taskNum = process(os.environ['TODO_FILE'], prefix, tasks, completed, priority)
	global taskWidth
	taskWidth = int(math.ceil(math.log(taskNum,10)))

	process(os.environ['DONE_FILE'], prefix, completed, completed, priority)

def run(prefix, prefixDescription):
	tasks = {}
	completed = {}
	priority = []
	gather(prefix, tasks, completed, priority)

	percentages = {}
	for task in tasks:
		openTasks = tasks[task]
		if task in completed:
			closedTasks = completed[task]
		else:
			closedTasks = 0
		totalTasks = openTasks + closedTasks
		percentages[task] = (closedTasks*100) / totalTasks

	# get tasks all done
	tasksWithNoIncompletes = {}
	for task in completed:
		if task not in tasks:
			tasksWithNoIncompletes[task] = completed[task]
	
	printTaskGroups("%s with open tasks"% (prefixDescription, ), tasks, priority, percentages)
	printTaskGroups("completed %s (no open tasks)"% (prefixDescription, ), tasksWithNoIncompletes, priority, percentages)

def main(argv):
	# make sure you have all your args
	if len(argv) < 2:
		usage()
		sys.exit(2)

	run('+', 'projects')
	run('@', 'contexts')
	print ""
	print "* prioritized tasks, listed first. Items are sorted by number of open tasks."

if __name__ == "__main__":
	main(sys.argv[1:])
