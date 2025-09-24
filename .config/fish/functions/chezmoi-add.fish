
function add_chezmoi_files --description "Add multiple files to chezmoi from a list"
    # Check if a file is provided as an argument
    if test (count $argv) -ne 1
        echo "Usage: add_chezmoi_files <file_with_paths>"
        return 1
    end

    set -l FILE $argv[1]

    # Check if the provided file exists
    if not test -f "$FILE"
        echo "Error: File '$FILE' not found."
        return 1
    end

    echo "Processing file: $FILE"

    # Read the file line by line and run chezmoi add
    cat "$FILE" | while read -l line
        # Skip empty lines
        if test -z "$line"
            continue
        end

        echo "Running: chezmoi add \"$line\""
        chezmoi add "$line"
        # Optional: Add error checking here if needed
        # if test $status -ne 0
        #   echo "Error adding $line"
        # end
    end

    echo "Finished processing."
end

##!/bin/bash
#
## Check if a file is provided as an argument
#if [ -z "$1" ]; then
#  echo "Usage: $0 <file_with_paths>"
#  exit 1
#fi
#
#FILE="$1"
#
## Check if the provided file exists
#if [ ! -f "$FILE" ]; then
#  echo "Error: File '$FILE' not found."
#  exit 1
#fi
#
#echo "Processing file: $FILE"
#
## Read the file line by line
#while IFS= read -r line; do
#  # Skip empty lines
#  if [ -z "$line" ]; then
#    continue
#  fi
#
#  echo "Running: chezmoi add \"$line\""
#  chezmoi add "$line"
#  # You might want to add error checking here, e.g.:
#  # if [ $? -ne 0 ]; then
#  #   echo "Error adding $line"
#  # fi
#done <"$FILE"
#
#echo "Finished processing."
