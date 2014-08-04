#! /bin/bash
#
# Ugh. I can't remember doing this. These are some simple functions that will
# wrap text in ANSI escape sequences. Well, it works.

function ansicolor {

	case $1 in
		black)
			num=0;;
		red)
			num=1;;
		green)
			num=2;;
		yellow)
			num=3;;
		blue)
			num=4;;
		magenta)
			num=5;;
		cyan)
			num=6;;
		white)
			num=7;;
		*)
			num="9";;  # I have no idea why this is a string. I'm guessing no
                       # reason.
	esac

	echo $num
}

ansifg=30
ansibg=40

function bold    { echo "\033[1m$@\033[0m"; }
function uline   { echo "\033[4m$@\033[0m"; }
function blink   { echo "\033[5m$@\033[0m"; }
function reverse { echo "\033[7m$@\033[0m"; }
function frame   { echo "\033[51m$@\033[0m"; }
function circle  { echo "\033[52m$@\033[0m"; }
function fgcolor { color=$1; shift; echo "\033[$((`ansicolor $color` + $ansifg))m$@\033[0m"; }
function bgcolor { color=$1; shift; echo "\033[$((`ansicolor $color` + $ansibg))m$@\033[0m"; }
