#!/bin/bash source-this-script
###############################################################################
##
# FILE:         common.sh
# PRODUCT:      todo.txt-cli-ex
# AUTHOR:       Ingo Karkat <ingo@karkat.de>
# DATE CREATED: 23-Nov-2013
#
###############################################################################
# CONTENTS:
#   Common functions used by multiple actions.
#
# REMARKS:
#
# @(#)common.sh	$Id$	todo.txt-cli-ex
###############################################################################

donePriAndDateExpr='^\([xX] \([0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} \)\{0,1\}\)\{0,1\}\((.) \)\{0,1\}\([0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} \)\{0,1\}\(\([+@][^ ]\+ \+\|[[:graph:]]:\(([^)]\+)\|[^ ]\+\) \+\|{[^{}]\+} \+\)\{0,\}\)\(.*$\)'
splitTodo()
{
    doneMarkerAndDate=$(echo "${1:?}" | sed -e "s/${donePriAndDateExpr}/\\1/")
    priAndAddDate=$(echo "${1}" | sed -e "s/${donePriAndDateExpr}/\\3\\4/")
    prepends=$(echo "${1}" | sed -e "s/${donePriAndDateExpr}/\\5/")
    rest=$(echo "$1" | sed -e 's/^\([xX] \([0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} \)\{0,1\}\)\{0,1\}\((.) \)\{0,1\}\([0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} \)\{0,1\}\(\([+@][^ ]\+ \+\|[[:graph:]]:\(([^)]\+)\|[^ ]\+\) \+\|{[^{}]\+} \+\)\{0,\}\)\(.*$\)/\8/')
    text=$(echo "$rest" | sed -e 's/\(\( \+[+@][^ ]\+\| \+[[:graph:]]:\(([^)]\+)\|[^ ]\+\)\| \+{[^{}]\+}\)\{0,\}\)$//')
    appends=${rest#"$text"}
}
