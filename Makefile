CC = gcc
OPT = -lfl
FLEX = flex
TARGET = Converter
SOURCE = sample.java

all: run

run: compile
	./$(TARGET) < $(SOURCE)

compile: flex
	$(CC) -o $(TARGET) lex.yy.c $(OPT)

flex: highlighter.l
	$(FLEX) highlighter.l

clean:
	rm $(TARGET)
	rm lex.yy.c
	rm output.html
