#!/bin/bash
#: Description	: Downloads a zip file and sorts it contents into folder based on file extensions passed as command-line arguments
#: Author		: Murray Watson
clear

#https://blackboard.gcal.ac.uk/bbcswebdav/pid-1825765-dt-content-rid-2078438_2/courses/M1I323146-15-AB/unsorted_files%283%29.zip

function sort_files() {
	#@ USAGE		: creates dir with dirname passed and puts files with file_ext passed into the dir created
	#@ ARGUEMENTS	: $1 = directory name and $2 = file extension
	dir_name="$1"
	## creates anew directory with the name passed as the first argument
	mkdir "$dir_name"
	check_errors "An error occurred while creating or moving files.\n"

	## loops through list of files with the file ext passed
	for x in *"$2"; do
		## if the file - $x - isn't a dir it moves it to dir for file extension passed
		[ ! -d "$x" ] && mv "$x" "$dir_name"
	done

	## calls the function to create the output for the dir
	output_file "$dir_name"
}

function output_file() {
	#@ USAGE		: puts contents of dir passed into a file in order of size
	#@ ARGUEMENTS	: $1 = directory name
	file_name="$1/output.txt"
	## creates an empty file
	touch "$file_name"
	## -S lists files in order of size
	## redirects the output of 'ls' to our empty file
	ls "$dir_name" -S > "$file_name"
}

function check_errors() {
	#@ USAGE		: prints error message and exits if current exit status isn't zero,
	#				  It exits the script to prevent any further errors occuring.
	#@ ARGUEMENTS 	: $1 = error message
	[ $? -ne 0 ] && printf "$1" && exit
}

## prints error and exits if no file extensions are passed
[ $# -le 0 ] && printf "Pass at least one file extension.\n" && exit

## gets url, user-name and password to download zip file
## -s stops user input being displayed
## -p allows us to prompt user with msg for input
printf "Leave user-name and password blank if not required.\n"
read -p "URL of unsorted zip File: " url
read -p "User-name: " user
read -s -p "Password: " pass
## -p doesn't print a newline, so this does
printf "\n"

## this what the zip being downloaded will be called and the name of the directory when it's extracted
zip_name="unsorted_files"

## downloads zip file from url, username and password provided
## -O, lets us name the output of the download, so the zip will be called "unsorted_files"
## -q, makes wget run quiet and --show-progress shows the download bar
wget -O "$zip_name.zip" -q -c --show-progress --user "$user" --password "$pass" "$url"

#check_errors "An error has occurred while downloading the zip file. Please check username, password and url are correct.\n"

## unzips zip and cd's into unzipped dir
## -j extracts files direct to directory and not to sub directory, so extracts to /zipname/files instead of /zipname/zipname/files
## -d allows us to specify the name of the directory the files are extracted to
## '1>' redirects standard input to a null file, but any errors will still be displayed
unzip -j "$zip_name.zip" -d "$zip_name" 1> /dev/null
cd "$zip_name"

check_errors "An error has occurred while extracting zip file.\n"

## lets the user know the zip file was downloaded without any issues and what the zip was called
printf "Zip File Downloaded without any issues. Zip is called: %s.zip\n" "$zip_name"

## loops through list of command-line arguments(file extensions passed), and calls sort_files with them as the arguments
for i in "$@"; do sort_files "$i" "$i"; done

## puts remaining file into misc folder
sort_files "misc" ""

## creates output file with of every dir and their contents listed in reverse alph order
file_name="output.txt"
## creates an empty file called 'output.txt'
touch "$file_name"
# -R lists all files, dirs and their contents
# -r lists files in reverse order
ls -R -r > "$file_name"

## lets the user know everything has been extracted and sorted and where to.
printf "Files extracted and sorted to a directory called: %s.\n" "$zip_name"

## PERSONAL REFLECTION ##
# My script is currently working and has handled all errors that have been tested, such as invalid urls, invalid username/password,
# problems making directories etc. I think I approached the task rather half-hearted, i didn't really take the time to think about
# how the script would work, and what the flow of the script would be, if i were to do the task again i'd take some time before creating
# the script, to plan out what functions it would need, the flow of the script, how it'd handle errors etc. I'd also add two extra options
# for command-line arguments that would allow the user to add the option, -url, then the website url, and then -login, which would
# indicate a username/password is required and the user would then enter them in the script(the password can be hidden when entered in
# the script, but can't as when passed as a cmd-line arg.). I've learned a lot more about the options of the 'ls' command while creating
# this script, the different ways that the contents of a dir can be listed. I also learned that 'ls' by default lists the dir contents
# in alphabetical order.
