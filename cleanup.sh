#!/bin/bash
#: Description	: Removes the directory's/files passed as command-line arguments
#: Author		: Murray Watson (MWATSO205@caledonian.ac.uk)
clear

## prints error if no dirs or files are passed
[ $# -eq 0 ] && printf "Please pass at least one directory or file to remove.\n" && exit

## loop through command-line arguments, removing each dir/file checking if any errors occurred after each loop
## -r allows us to remove dirs as well as files
for i in "$@"; do
	rm -r "$i"
	## $?, is the current exit status, which is zero if no errors occurred while removing the directory/file
	## prints success msg if dir/file is removed with no problems and err msg if not
	[ $? -eq 0 ] && printf "removed: $i\n\n" || printf "An error occurred while removing: $i\n\n"
done