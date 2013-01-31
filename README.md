usefold
========

vimscript to simplify manual fold creation

### Functions
**Usefold_Folder()** takes a line number, and searches downwards for a line that has the same
indentlevel and creates a fold including these. Unless the filetype is set to python that
does not have the equivalent of a closing brace.
Empty lines and lines with only whitespace are skipped during search, and not included
in the fold if possible. (i.e. in the python case, when the beginning of the next block
has been found, it is the previous line that contains something other than whitespace
and not just *any* line that is considered the last line of the block)

**Usefold_FromHere()** runs **Usefold_Folder()** on the current line.

**Usefold_FromInside()** stores the indentlevel of the current line and searches upwards for
the first line that is indented less and then runs **Usefold_Folder()** on that line.

**Usefold_foldtext()** provides an *foldtext()* implementation that preserves the indent level
of the folded block in the fold comment.

### Example
    int foo(void) {
        do_stuff();
        for (int i=0; i<128; ++i) {
            do_other_stuff(i);
        }
    }

Assuming the cursor is placed on line 5, the initialization of the for loop,

- running **Usefold_FromHere()** will append opening and closing markers on line 3 and line 5 respectively.
- running **Usefold_FromInside()** will append opening and closing markers on line 1 and line 6 respectively.


### Possible problems
Some effort has been made to make it language agnostic (basically by using &commentstring
when creating fold markers, as well as checking for &filetype=python).

All combinations of the functions and empty or whitespace-only lines has not yet been checked. Expect bugs.
