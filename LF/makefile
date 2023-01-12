analisa: lex.yy.o
	cc -g -o analisa analisador.tab.c lex.yy.o

lex.yy.o: lex.yy.c analisador.tab.h
	cc -g -c lex.yy.c

lex.yy.c: analisador.l analisador.tab.h
	flex analisador.l

analisador.tab.h analisador.tab.c: analisador.y
	bison -d analisador.y

