set -l tmpfile /tmp/yazi-choice.txt
rm -f $tmpfile
yazi --chooser-file=$tmpfile
zellij action toggle-floating-panes
zellij action write 27 # send escape-key
zellij action write-chars ":open $(cat /tmp/yazi-choice.txt)"
zellij action write 13 # send enter-key
zellij action toggle-floating-panes
zellij action close-pane
