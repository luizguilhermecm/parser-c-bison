FLEX=flex
BISON=bison
CC=gcc

PROGRAM = language-c
LEXICAL = lexical-c.l
SYNTAX = syntax-c.y


$(PROGRAM): $(LEXICAL) $(SYNTAX)
	$(BISON) -d $(SYNTAX)
	$(FLEX) $(LEXICAL)
	$(CC) -c *.c -I.
	$(CC) *.o -o $(PROGRAM)

clean:
	rm -f *.yy.c
	rm -f *.tab.c
	rm -f *.tab.h
	rm -f *.o
	rm -f *.exe
