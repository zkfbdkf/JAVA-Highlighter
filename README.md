Java code to Html with highlighting
--------------------------
This program does convert java code to HTML code.
The input file should be .java file, and the ouput will be .html file.
In the HTML file, the syntax of java code such as declaration of variables will be highlited.
Moreover, the sysntax error is represented to strikethrough.



How to Run?
__________________________
1. put the highlighter.l, sample.java and Makefile files in the same directory.

2. run flex and compile and run with command $make

3. output.html will be created


Other command
__________________________
1. $make clean: remove created lex.yy.c and converter files.


Arguments
__________________________
Input file should be sample.java.
