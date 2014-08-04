# This is a silly makefile to compile an applescript

RM=rm -vrf
APPLESCRIPT=songstat

default: $(APPLESCRIPT).scptd

%.scptd: %.applescript
	osacompile -o $@ $?

%.scpt: %.applescript
	osacompile -o $@ $?

clean:
	@$(RM) *.scpt *.scptd
