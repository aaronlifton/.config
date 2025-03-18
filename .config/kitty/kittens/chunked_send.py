#!/usr/bin/env python3

"""
this is for sending text from the main window of a kitty tab to the window that
holds the repl

TODO: this could be made smarter to take in a custom --match= so that editor tooling
      can control how to instantiate the repl and send to the correct window

test

echo echo sup | kitty @ send-text --match=num:1 --stdin

"""

import sys
import subprocess

always_newline = False

if "-r" in sys.argv:
    # some repls do not understand the escape code for deleting
    # the previous character, and they fortunately do not have a pager
    # so just disable this. like when we are using gforth
    default_reset = ""
else:
    # q and ctrl-u
    # q      : quits out of a pager you are potentially in
    # ctrl-u : deletes q in case we were not in a pager
    default_reset = "q\025"

if "-d" in sys.argv:
    # always append a \r\n
    always_newline = True

echo_input = False
if "-e" in sys.argv:
    # helix does not seem to have a version of :pipe
    # that does not delete the input. instead always
    # replaces it with output from the script
    echo_input = True

# warning: this buffers all of stdin into memory
lines = sys.stdin.readlines()
batch_size = 10

to_echo = ""
# lump this into the first batch to speed up flushing

batch = []
for i in range(0, len(lines), batch_size):
    batch += lines[i : i + batch_size]

    clear_repl = default_reset if i == 0 else ""
    # add an extra ENTER key if there was none at the end
    extra_newline = ""
    if always_newline:
        # \r\n because this feature was added for janet, and janet only
        # recognizes newlines with carriage returns
        extra_newline = "\r\n"
    else:
        if len(lines) <= (i + batch_size) and batch[-1][-1] != "\n":
            extra_newline = "\n"

    current_batch = "".join(batch)
    kitty = subprocess.run(
        ["kitty", "@", "send-text", "--match=num:1", "--stdin"],
        input=clear_repl + current_batch + extra_newline,
        encoding="ascii",
    )

    if echo_input:
        to_echo += current_batch
    batch = []

_ = sys.stdout.write(to_echo)
