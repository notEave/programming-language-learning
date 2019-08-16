
# Parse a bash variable in the form:
# stdin=\
# "This is a multiline
# String"

sed -z -n 's/.*stdin=\\\n"\(.*\)".*/\1\n/p' tset
awk '/field=/,/"$/' file | tr -d '"' | tail -n +2

# something comes before
# stdin=\
# "this is a multiline
# string in bash
# hello world"
# something comes after

