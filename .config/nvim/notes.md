# Notes

### `g<C-a>`

```help
|v_CTRL-A| CTRL-A 2 add N to number in highlighted text |v_CTRL-C| CTRL-C stop Visual mode
|v_CTRL-X|	CTRL-X		2  subtract N from number in highlighted text
|v_CTRL-G|	CTRL-G		   toggle between Visual mode and Select mode
|v_CTRL-O|	CTRL-O		   switch from Select to Visual mode for one
           command
|v_CTRL-V|	CTRL-V		   make Visual mode blockwise or stop Visual
|v_<Esc>|	<Esc>		   stop Visual mode
|v_:|		:		   start a command-line with the highlighted
|v_b_A|		A		2  block mode: append same text in all lines,
|v_C|		C		2  delete the highlighted lines and start
|v_b_I|		I		2  block mode: insert same text in all lines,
before the highlighted area
insert
after the highlighted area
lines as a range
|v_R|		R		2  delete the highlighted lines and start
           insert
|v_S|		S		2  delete the highlighted lines and start
           insert
|v_U|		U		2  make highlighted area uppercase
|v_V|		V		   make Visual mode linewise or stop Visual
           mode
|v_X|		X		2  delete the highlighted lines
|v_Y|		Y		   yank the highlighted lines
|v_g_CTRL-A|	g CTRL-A	2  add N to number in highlighted text
|v_g_CTRL-X|	g CTRL-X	2  subtract N from number in highlighted text
|v_gJ|		gJ		2  join the highlighted lines without
           inserting spaces
|v_gq|		gq		2  format the highlighted lines
|v_gv|		gv		   exchange current and previous highlighted
           area
|v_iquote|	i"		   extend highlighted area with a double
           quoted string (without quotes)
|v_i'|		i'		   extend highlighted area with a single
           quoted string (without quotes)
|v_i(|		i(		   same as ib
|v_i)|		i)		   same as ib
|v_o|		o		   move cursor to other corner of area
|v_p|		p		   replace highlighted area with register
                      contents; deleted text in unnamed register
|v_r|		r		2  replace highlighted area with a character
|v_s|		s		2  delete highlighted area and start insert
|v_u|		u		2  make highlighted area lowercase
|v_v|		v		   make Visual mode charwise or stop
				   Visual mode
|v_x|		x		2  delete the highlighted area
|v_y|		y		   yank the highlighted area
|v_~|		~		2  swap case for the highlighted area

tag		char		action in Operator-pending mode	~
------------------------------------------------------------------------------ ~
|o_v|		v		force operator to work charwise
|o_V|		V		force operator to work linewise
|o_CTRL-V|	CTRL-V		force operator to work blockwise
```

## Async code references

```
  fzf resume  1
   └╴󰢱  ~/.local/share/nvim/lazy/codecompanion.nvim/lua/codecompanion/utils/log.lua  1
     └╴local a = require("plenary.async") [57, 22]
  fzf   5
   ├╴󰢱  ~/.local/share/nvim/lazy/crates.nvim/lua/crates/core.lua  1
   │ └╴local async = require("crates.async") [2, 7]
   ├╴󰢱  ~/.local/share/nvim/lazy/fzf-lua/lua/fzf-lua/core.lua  1
   │ └╴if is_async then [125, 17]
   ├╴󰢱  ~/.local/share/nvim/lazy/fzf-lua/lua/fzf-lua/providers/lsp.lua  1
   │ └╴local async_buf_request = function() [565, 15]
   ├╴󰢱  ~/.local/share/nvim/lazy/fzf-lua/lua/fzf-lua/utils.lua  1
   │ └╴M.read_file_async = function(filepath, callback) [310, 13]
   └╴󰢱  ~/.local/share/nvim/lazy/nvim-cmp/lua/cmp/utils/async.lua  1
     └╴async.throttle = function(fn, timeout) [30, 1]
```

## zz

`:h zz`

```
z{height}<CR>		Redraw, make window {height} lines tall.  This is
      useful to make the number of lines small when screen
      updating is very slow.  Cannot make the height more
      than the physical screen height.

*zs*
zs			Scroll the text horizontally to position the cursor
at the start (left side) of the screen.  This only
works when 'wrap' is off.

*ze*
ze			Scroll the text horizontally to position the cursor
at the end (right side) of the screen.  This only
works when 'wrap' is off.

```

## Helpfiles

`:h pattern` - for regex syntax when searching

```help
Overview of ordinary atoms.				*/ordinary-atom*
More explanation and examples below, follow the links.

      ordinary atom ~
      magic   nomagic	matches ~
|/^|	^	^	start-of-line (at start of pattern) |/zero-width|
|/\^|	\^	\^	literal '^'
|/\_^|	\_^	\_^	start-of-line (used anywhere) |/zero-width|
|/$|	$	$	end-of-line (at end of pattern) |/zero-width|
|/\$|	\$	\$	literal '$'
|/\_$|	\_$	\_$	end-of-line (used anywhere) |/zero-width|
|/.|	.	\.	any single character (not an end-of-line)
|/\_.|	\_.	\_.	any single character or end-of-line
|/\<|	\<	\<	beginning of a word |/zero-width|
|/\>|	\>	\>	end of a word |/zero-width|
|/\zs|	\zs	\zs	anything, sets start of match
|/\ze|	\ze	\ze	anything, sets end of match
|/\%^|	\%^	\%^	beginning of file |/zero-width|		*E71*
|/\%$|	\%$	\%$	end of file |/zero-width|
|/\%V|	\%V	\%V	inside Visual area |/zero-width|
|/\%#|	\%#	\%#	cursor position |/zero-width|
|/\%'m|	\%'m	\%'m	mark m position |/zero-width|
|/\%l|	\%23l	\%23l	in line 23 |/zero-width|
|/\%c|	\%23c	\%23c	in column 23 |/zero-width|
|/\%v|	\%23v	\%23v	in virtual column 23 |/zero-width|

Character classes:					*/character-classes*
      magic   nomagic	matches ~
|/\i|	\i	\i	identifier character (see 'isident' option)
|/\I|	\I	\I	like "\i", but excluding digits
|/\k|	\k	\k	keyword character (see 'iskeyword' option)
|/\K|	\K	\K	like "\k", but excluding digits
|/\f|	\f	\f	file name character (see 'isfname' option)
|/\F|	\F	\F	like "\f", but excluding digits
|/\p|	\p	\p	printable character (see 'isprint' option)
|/\P|	\P	\P	like "\p", but excluding digits
|/\s|	\s	\s	whitespace character: <Space> and <Tab>
|/\S|	\S	\S	non-whitespace character; opposite of \s
|/\d|	\d	\d	digit:				[0-9]
|/\D|	\D	\D	non-digit:			[^0-9]
|/\x|	\x	\x	hex digit:			[0-9A-Fa-f]
|/\X|	\X	\X	non-hex digit:			[^0-9A-Fa-f]
|/\o|	\o	\o	octal digit:			[0-7]
|/\O|	\O	\O	non-octal digit:		[^0-7]
|/\w|	\w	\w	word character:			[0-9A-Za-z_]
|/\W|	\W	\W	non-word character:		[^0-9A-Za-z_]
|/\h|	\h	\h	head of word character:		[A-Za-z_]
|/\H|	\H	\H	non-head of word character:	[^A-Za-z_]
|/\a|	\a	\a	alphabetic character:		[A-Za-z]
|/\A|	\A	\A	non-alphabetic character:	[^A-Za-z]
|/\l|	\l	\l	lowercase character:		[a-z]
|/\L|	\L	\L	non-lowercase character:	[^a-z]
|/\u|	\u	\u	uppercase character:		[A-Z]
|/\U|	\U	\U	non-uppercase character		[^A-Z]
|/\_|	\_x	\_x	where x is any of the characters above: character
			class with end-of-line included
(end of character classes)

      magic   nomagic	matches ~
|/\e|	\e	\e	<Esc>
|/\t|	\t	\t	<Tab>
|/\r|	\r	\r	<CR>
|/\b|	\b	\b	<BS>
|/\n|	\n	\n	end-of-line
|/~|	~	\~	last given substitute string
|/\1|	\1	\1	same string as matched by first \(\)
|/\2|	\2	\2	Like "\1", but uses second \(\)
	   ...
|/\9|	\9	\9	Like "\1", but uses ninth \(\)
								*E68*
|/\z1|	\z1	\z1	only for syntax highlighting, see |:syn-ext-match|
	   ...
|/\z1|	\z9	\z9	only for syntax highlighting, see |:syn-ext-match|

	x	x	a character with no special meaning matches itself

|/[]|	[]	\[]	any character specified inside the []
|/\%[]|	\%[]	\%[]	a sequence of optionally matched atoms

|/\c|	\c	\c	ignore case, do not use the 'ignorecase' option
|/\C|	\C	\C	match case, do not use the 'ignorecase' option
|/\Z|	\Z	\Z	ignore differences in Unicode "combining characters".
			Useful when searching voweled Hebrew or Arabic text.

      magic   nomagic	matches ~
|/\m|	\m	\m	'magic' on for the following chars in the pattern
|/\M|	\M	\M	'magic' off for the following chars in the pattern
|/\v|	\v	\v	the following chars in the pattern are "very magic"
|/\V|	\V	\V	the following chars in the pattern are "very nomagic"
|/\%#=|   \%#=1   \%#=1   select regexp engine |/zero-width|

|/\%d|	\%d	\%d	match specified decimal character (eg \%d123)
|/\%x|	\%x	\%x	match specified hex character (eg \%x2a)
|/\%o|	\%o	\%o	match specified octal character (eg \%o040)
|/\%u|	\%u	\%u	match specified multibyte character (eg \%u20ac)
|/\%U|	\%U	\%U	match specified large multibyte character (eg
			\%U12345678)
|/\%C|	\%C	\%C	match any composing characters

Example			matches ~
\<\I\i*		or
\<\h\w*
\<[a-zA-Z_][a-zA-Z0-9_]*
			An identifier (e.g., in a C program).

\(\.$\|\. \)		A period followed by <EOL> or a space.

[.!?][])"']*\($\|[ ]\)	A search pattern that finds the end of a sentence,
			with almost the same definition as the ")" command.

cat\Z			Both "cat" and "càt" ("a" followed by 0x0300)
			Does not match "càt" (character 0x00e0), even
			though it may look the same.


```

## Reselect previous selection

`gv`

## Keybindings to learn

```help
These commands are not marks themselves, but jump to a mark:

              *]'*
]'			[count] times to next line with a lowercase mark below
      the cursor, on the first non-blank character in the
      line.

              *]`*
]`			[count] times to lowercase mark after the cursor.

              *['*
['			[count] times to previous line with a lowercase mark
      before the cursor, on the first non-blank character in
      the line.

              *[`*
[`			[count] times to lowercase mark before the cursor.

*'<* *`<*
'<  `<			To the first line or character of the last selected
Visual area in the current buffer.  For block mode it
may also be the last character in the first line (to
be able to define the block).

*'>* *`>*
'>  `>			To the last line or character of the last selected
Visual area in the current buffer.  For block mode it
may also be the first character of the last line (to
be able to define the block).  Note that 'selection'
applies, the position may be just after the Visual
area.

*''* *``*
''  ``			To the position before the latest jump, or where the
last "m'" or "m`" command was given.  Not set when the
|:keepjumps| command modifier was used.
Also see |restore-position|.

*'quote* *`quote*
'"  `"			To the cursor position when last exiting the current
buffer.  Defaults to the first character of the first
line.  See |last-position-jump| for how to use this
for each opened file.
Only one position is remembered per buffer, not one
for each window.  As long as the buffer is visible in
a window the position won't be changed.  Mark is also
reset when |:wshada| is run.

*'^* *`^*
'^  `^			To the position where the cursor was the last time
when Insert mode was stopped.  This is used by the
|gi| command.  Not set when the |:keepjumps| command
modifier was used.

*'.* *`.*
'.  `.			To the position where the last change was made.  The
position is at or near where the change started.
Sometimes a command is executed as several changes,
then the position can be near the end of what the
command changed.  For example when inserting a word,
the position will be on the last character.
To jump to older changes use |g;|.

```

```help

CTRL-W p					*CTRL-W_p* *CTRL-W_CTRL-P*
CTRL-W CTRL-P	Go to previous (last accessed) window.
            *CTRL-W_P* *E441*
CTRL-W w					*CTRL-W_w* *CTRL-W_CTRL-W*
CTRL-W CTRL-W	Without count: move cursor to window below/right of the
    current one.  If there is no window below or right, go to
    top-left window.
    With count: go to Nth window (windows are numbered from
    top-left to bottom-right).  To obtain the window number see
    |bufwinnr()| and |winnr()|.  When N is larger than the number
    of windows go to the last window.

            *CTRL-W_W*
CTRL-W W	Without count: move cursor to window above/left of current
    one.  If there is no window above or left, go to bottom-right
    window.  With count: go to Nth window, like with CTRL-W w.
CTRL-W t					*CTRL-W_t* *CTRL-W_CTRL-T*
CTRL-W CTRL-T	Move cursor to top-left window.

CTRL-W b					*CTRL-W_b* *CTRL-W_CTRL-B*
CTRL-W CTRL-B	Move cursor to bottom-right window.

CTRL-W p					*CTRL-W_p* *CTRL-W_CTRL-P*
CTRL-W CTRL-P	Go to previous (last accessed) window.
            *CTRL-W_P* *E441*
CTRL-W P	Go to preview window.  When there is no preview window this is
    an error.
            *CTRL-W_T*
CTRL-W T	Move the current window to a new tab page.  This fails if
    there is only one window in the current tab page.
    This works like `:tab split`, except the previous window is
    closed.
    When a count is specified the new tab page will be opened
    before the tab page with this index.  Otherwise it comes after
    the current tab page.
CTRL-W r				*CTRL-W_r* *CTRL-W_CTRL-R* *E443*
CTRL-W CTRL-R	Rotate windows downwards/rightwards.  The first window becomes
		the second one, the second one becomes the third one, etc.
		The last window becomes the first window.  The cursor remains
		in the same window.
		This only works within the row or column of windows that the
		current window is in.

						*CTRL-W_R*
CTRL-W R	Rotate windows upwards/leftwards.  The second window becomes
		the first one, the third one becomes the second one, etc.  The
		first window becomes the last window.  The cursor remains in
		the same window.
		This only works within the row or column of windows that the
		current window is in.

CTRL-W x					*CTRL-W_x* *CTRL-W_CTRL-X*
CTRL-W CTRL-X	Without count: Exchange current window with next one.  If there
		is no next window, exchange with previous window.
		With count: Exchange current window with Nth window (first
		window is 1).  The cursor is put in the other window.
		When vertical and horizontal window splits are mixed, the
		exchange is only done in the row or column of windows that the
		current window is in.
```

## Default nvim keybindings

### Ctrl-w

```help
==============================================================================
4. Moving cursor to other windows			*window-move-cursor*

CTRL-W w					*CTRL-W_w* *CTRL-W_CTRL-W*
CTRL-W CTRL-W	Without count: move cursor to window below/right of the
    current one.  If there is no window below or right, go to
    top-left window.
    With count: go to Nth window (windows are numbered from
    top-left to bottom-right).  To obtain the window number see
    |bufwinnr()| and |winnr()|.  When N is larger than the number
    of windows go to the last window.

            *CTRL-W_W*
CTRL-W W	Without count: move cursor to window above/left of current
    one.  If there is no window above or left, go to bottom-right
    window.  With count: go to Nth window, like with CTRL-W w.

CTRL-W t					*CTRL-W_t* *CTRL-W_CTRL-T*
CTRL-W CTRL-T	Move cursor to top-left window.

CTRL-W b					*CTRL-W_b* *CTRL-W_CTRL-B*
CTRL-W CTRL-B	Move cursor to bottom-right window.

CTRL-W p					*CTRL-W_p* *CTRL-W_CTRL-P*
CTRL-W CTRL-P	Go to previous (last accessed) window.
            *CTRL-W_P* *E441*
CTRL-W P	Go to preview window.  When there is no preview window this is
    an error.
CTRL-W r				*CTRL-W_r* *CTRL-W_CTRL-R* *E443*
CTRL-W CTRL-R	Rotate windows downwards/rightwards.  The first window becomes
    the second one, the second one becomes the third one, etc.
    The last window becomes the first window.  The cursor remains
    in the same window.
    This only works within the row or column of windows that the
    current window is in.

            *CTRL-W_R*
CTRL-W R	Rotate windows upwards/leftwards.  The second window becomes
    the first one, the third one becomes the second one, etc.  The
    first window becomes the last window.  The cursor remains in
    the same window.
    This only works within the row or column of windows that the
    current window is in.

CTRL-W x					*CTRL-W_x* *CTRL-W_CTRL-X*
CTRL-W CTRL-X	Without count: Exchange current window with next one.  If there
    is no next window, exchange with previous window.
    With count: Exchange current window with Nth window (first
    window is 1).  The cursor is put in the other window.
    When vertical and horizontal window splits are mixed, the
    exchange is only done in the row or column of windows that the
    current window is in.

==============================================================================
5. Moving windows around				*window-moving*

CTRL-W r				*CTRL-W_r* *CTRL-W_CTRL-R* *E443*
CTRL-W CTRL-R	Rotate windows downwards/rightwards.  The first window becomes
    the second one, the second one becomes the third one, etc.
    The last window becomes the first window.  The cursor remains
    in the same window.
    This only works within the row or column of windows that the
    current window is in.

            *CTRL-W_R*
CTRL-W R	Rotate windows upwards/leftwards.  The second window becomes
    the first one, the third one becomes the second one, etc.  The
    first window becomes the last window.  The cursor remains in
    the same window.
    This only works within the row or column of windows that the
    current window is in.

CTRL-W x					*CTRL-W_x* *CTRL-W_CTRL-X*
CTRL-W CTRL-X	Without count: Exchange current window with next one.  If there
    is no next window, exchange with previous window.
    With count: Exchange current window with Nth window (first
    window is 1).  The cursor is put in the other window.
    When vertical and horizontal window splits are mixed, the
    exchange is only done in the row or column of windows that the
    current window is in.

The following commands can be used to change the window layout.  For example,
when there are two vertically split windows, CTRL-W K will change that in
horizontally split windows.  CTRL-W H does it the other way around.

            *CTRL-W_K*
CTRL-W K	Move the current window to be at the very top, using the full
    width of the screen.  This works like `:topleft split`, except
    it is applied to the current window and no new window is
    created.

            *CTRL-W_J*
CTRL-W J	Move the current window to be at the very bottom, using the
    full width of the screen.  This works like `:botright split`,
    except it is applied to the current window and no new window
    is created.

            *CTRL-W_H*
CTRL-W H	Move the current window to be at the far left, using the
    full height of the screen.  This works like
    `:vert topleft split`, except it is applied to the current
    window and no new window is created.

            *CTRL-W_L*
CTRL-W L	Move the current window to be at the far right, using the full
    height of the screen.  This works like `:vert botright split`,
    except it is applied to the current window and no new window
    is created.

            *CTRL-W_T*
CTRL-W T	Move the current window to a new tab page.  This fails if
    there is only one window in the current tab page.
    This works like `:tab split`, except the previous window is
    closed.
    When a count is specified the new tab page will be opened
    before the tab page with this index.  Otherwise it comes after
    the current tab page.

==============================================================================
2.2 Window commands						*CTRL-W*

tag		command		   action in Normal mode	~
------------------------------------------------------------------------------ ~
|CTRL-W_CTRL-B|	CTRL-W CTRL-B	   same as "CTRL-W b"
|CTRL-W_CTRL-C|	CTRL-W CTRL-C	   same as "CTRL-W c"
|CTRL-W_CTRL-D|	CTRL-W CTRL-D	   same as "CTRL-W d"
|CTRL-W_CTRL-F|	CTRL-W CTRL-F	   same as "CTRL-W f"
		CTRL-W CTRL-G	   same as "CTRL-W g .."
|CTRL-W_CTRL-H|	CTRL-W CTRL-H	   same as "CTRL-W h"
|CTRL-W_CTRL-I|	CTRL-W CTRL-I	   same as "CTRL-W i"
|CTRL-W_CTRL-J|	CTRL-W CTRL-J	   same as "CTRL-W j"
|CTRL-W_CTRL-K|	CTRL-W CTRL-K	   same as "CTRL-W k"
|CTRL-W_CTRL-L|	CTRL-W CTRL-L	   same as "CTRL-W l"
|CTRL-W_CTRL-N|	CTRL-W CTRL-N	   same as "CTRL-W n"
|CTRL-W_CTRL-O|	CTRL-W CTRL-O	   same as "CTRL-W o"
|CTRL-W_CTRL-P|	CTRL-W CTRL-P	   same as "CTRL-W p"
|CTRL-W_CTRL-Q|	CTRL-W CTRL-Q	   same as "CTRL-W q"
|CTRL-W_CTRL-R|	CTRL-W CTRL-R	   same as "CTRL-W r"
|CTRL-W_CTRL-S|	CTRL-W CTRL-S	   same as "CTRL-W s"
|CTRL-W_CTRL-T|	CTRL-W CTRL-T	   same as "CTRL-W t"
|CTRL-W_CTRL-V|	CTRL-W CTRL-V	   same as "CTRL-W v"
|CTRL-W_CTRL-W|	CTRL-W CTRL-W	   same as "CTRL-W w"
|CTRL-W_CTRL-X|	CTRL-W CTRL-X	   same as "CTRL-W x"
|CTRL-W_CTRL-Z|	CTRL-W CTRL-Z	   same as "CTRL-W z"
|CTRL-W_CTRL-]|	CTRL-W CTRL-]	   same as "CTRL-W ]"
|CTRL-W_CTRL-^|	CTRL-W CTRL-^	   same as "CTRL-W ^"
|CTRL-W_CTRL-_|	CTRL-W CTRL-_	   same as "CTRL-W _"
|CTRL-W_+|	CTRL-W +	   increase current window height N lines
|CTRL-W_-|	CTRL-W -	   decrease current window height N lines
|CTRL-W_<|	CTRL-W <	   decrease current window width N columns
|CTRL-W_=|	CTRL-W =	   make all windows the same height & width
|CTRL-W_>|	CTRL-W >	   increase current window width N columns
|CTRL-W_H|	CTRL-W H	   move current window to the far left
|CTRL-W_J|	CTRL-W J	   move current window to the very bottom
|CTRL-W_K|	CTRL-W K	   move current window to the very top
|CTRL-W_L|	CTRL-W L	   move current window to the far right
|CTRL-W_P|	CTRL-W P	   go to preview window
|CTRL-W_R|	CTRL-W R	   rotate windows upwards N times
|CTRL-W_S|	CTRL-W S	   same as "CTRL-W s"
|CTRL-W_T|	CTRL-W T	   move current window to a new tab page
|CTRL-W_W|	CTRL-W W	   go to N previous window (wrap around)
|CTRL-W_]|	CTRL-W ]	   split window and jump to tag under cursor
|CTRL-W_^|	CTRL-W ^	   split current window and edit alternate
				   file N
|CTRL-W__|	CTRL-W _	   set current window height to N (default:
				   very high)
|CTRL-W_b|	CTRL-W b	   go to bottom window
|CTRL-W_c|	CTRL-W c	   close current window (like |:close|)
|CTRL-W_d|	CTRL-W d	   split window and jump to definition under
				   the cursor
|CTRL-W_f|	CTRL-W f	   split window and edit file name under the
				   cursor
|CTRL-W_F|	CTRL-W F	   split window and edit file name under the
				   cursor and jump to the line number
				   following the file name.
|CTRL-W_g_CTRL-]| CTRL-W g CTRL-]  split window and do |:tjump| to tag under
				   cursor
|CTRL-W_g]|	CTRL-W g ]	   split window and do |:tselect| for tag
				   under cursor
|CTRL-W_g}|	CTRL-W g }	   do a |:ptjump| to the tag under the cursor
|CTRL-W_gf|	CTRL-W g f	   edit file name under the cursor in a new
				   tab page
|CTRL-W_gF|	CTRL-W g F	   edit file name under the cursor in a new
				   tab page and jump to the line number
				   following the file name.
|CTRL-W_gt|	CTRL-W g t	   same as `gt`: go to next tab page
|CTRL-W_gT|	CTRL-W g T	   same as `gT`: go to previous tab page
|CTRL-W_g<Tab>|	CTRL-W g <Tab>	   same as |g<Tab>|: go to last accessed tab
				   page
|CTRL-W_h|	CTRL-W h	   go to Nth left window (stop at first window)
|CTRL-W_i|	CTRL-W i	   split window and jump to declaration of
				   identifier under the cursor
|CTRL-W_j|	CTRL-W j	   go N windows down (stop at last window)
|CTRL-W_k|	CTRL-W k	   go N windows up (stop at first window)
|CTRL-W_l|	CTRL-W l	   go to Nth right window (stop at last window)
|CTRL-W_n|	CTRL-W n	   open new window, N lines high
|CTRL-W_o|	CTRL-W o	   close all but current window (like |:only|)
|CTRL-W_p|	CTRL-W p	   go to previous (last accessed) window
|CTRL-W_q|	CTRL-W q	   quit current window (like |:quit|)
|CTRL-W_r|	CTRL-W r	   rotate windows downwards N times
|CTRL-W_s|	CTRL-W s	   split current window in two parts, new
				   window N lines high
|CTRL-W_t|	CTRL-W t	   go to top window
|CTRL-W_v|	CTRL-W v	   split current window vertically, new window
				   N columns wide
|CTRL-W_w|	CTRL-W w	   go to N next window (wrap around)
|CTRL-W_x|	CTRL-W x	   exchange current window with window N
				   (default: next window)
|CTRL-W_z|	CTRL-W z	   close preview window
|CTRL-W_bar|	CTRL-W |	   set window width to N columns
|CTRL-W_}|	CTRL-W }	   show tag under cursor in preview window
|CTRL-W_<Down>|	CTRL-W <Down>	   same as "CTRL-W j"
|CTRL-W_<Up>|	CTRL-W <Up>	   same as "CTRL-W k"
|CTRL-W_<Left>|	CTRL-W <Left>	   same as "CTRL-W h"
|CTRL-W_<Right>| CTRL-W <Right>	   same as "CTRL-W l"
```

### g

```help
==============================================================================
4 Commands starting with 'g'						*g*

tag		char	      note action in Normal mode	~
------------------------------------------------------------------------------ ~
|g_CTRL-G|	g CTRL-G	   show information about current cursor
				   position
|g_CTRL-H|	g CTRL-H	   start Select block mode
|g_CTRL-]|	g CTRL-]	   |:tjump| to the tag under the cursor
|g#|		g#		1  like "#", but without using "\<" and "\>"
|g$|		g$		1  when 'wrap' off go to rightmost character of
				   the current line that is on the screen;
				   when 'wrap' on go to the rightmost character
				   of the current screen line
|g&|		g&		2  repeat last ":s" on all lines
|g'|		g'{mark}	1  like |'| but without changing the jumplist
|g`|		g`{mark}	1  like |`| but without changing the jumplist
|gstar|		g*		1  like "*", but without using "\<" and "\>"
|g+|		g+		   go to newer text state N times
|g,|		g,		1  go to N newer position in change list
|g-|		g-		   go to older text state N times
|g0|		g0		1  when 'wrap' off go to leftmost character of
				   the current line that is on the screen;
				   when 'wrap' on go to the leftmost character
				   of the current screen line
|g8|		g8		   print hex value of bytes used in UTF-8
				   character under the cursor
|g;|		g;		1  go to N older position in change list
|g<|		g<		   display previous command output
|g?|		g?		2  Rot13 encoding operator
|g?g?|		g??		2  Rot13 encode current line
|g?g?|		g?g?		2  Rot13 encode current line
|gD|		gD		1  go to definition of word under the cursor
				   in current file
|gE|		gE		1  go backwards to the end of the previous
				   WORD
|gH|		gH		   start Select line mode
|gI|		gI		2  like "I", but always start in column 1
|gJ|		gJ		2  join lines without inserting space
|gN|		gN	      1,2  find the previous match with the last used
				   search pattern and Visually select it
|gP|		["x]gP		2  put the text [from register x] before the
				   cursor N times, leave the cursor after it
|gQ|		gQ		   switch to "Ex" mode with Vim editing
|gR|		gR		2  enter Virtual Replace mode
|gT|		gT		   go to the previous tab page
|gU|		gU{motion}	2  make Nmove text uppercase
|gV|		gV		   don't reselect the previous Visual area
				   when executing a mapping or menu in Select
				   mode
|g]|		g]		   :tselect on the tag under the cursor
|g^|		g^		1  when 'wrap' off go to leftmost non-white
				   character of the current line that is on
				   the screen; when 'wrap' on go to the
				   leftmost non-white character of the current
				   screen line
|g_|		g_		1  cursor to the last CHAR N - 1 lines lower
|ga|		ga		   print ascii value of character under the
				   cursor
|gd|		gd		1  go to definition of word under the cursor
				   in current function
|ge|		ge		1  go backwards to the end of the previous
				   word
|gf|		gf		   start editing the file whose name is under
				   the cursor
|gF|		gF		   start editing the file whose name is under
				   the cursor and jump to the line number
				   following the filename.
|gg|		gg		1  cursor to line N, default first line
|gh|		gh		   start Select mode
|gi|		gi		2  like "i", but first move to the |'^| mark
|gj|		gj		1  like "j", but when 'wrap' on go N screen
				   lines down
|gk|		gk		1  like "k", but when 'wrap' on go N screen
				   lines up
|gm|		gm		1  go to character at middle of the screenline
|gM|		gM		1  go to character at middle of the text line
|gn|		gn	      1,2  find the next match with the last used
				   search pattern and Visually select it
|go|		go		1  cursor to byte N in the buffer
|gp|		["x]gp		2  put the text [from register x] after the
				   cursor N times, leave the cursor after it
|gq|		gq{motion}	2  format Nmove text
|gr|		gr{char}	2  virtual replace N chars with {char}
|gs|		gs		   go to sleep for N seconds (default 1)
|gt|		gt		   go to the next tab page
|gu|		gu{motion}	2  make Nmove text lowercase
|gv|		gv		   reselect the previous Visual area
|gw|		gw{motion}	2  format Nmove text and keep cursor
|netrw-gx|	gx		   execute application for file name under the
				   cursor (only with |netrw| plugin)
|g@|		g@{motion}	   call 'operatorfunc'
|g~|		g~{motion}	2  swap case for Nmove text
|g<Down>|	g<Down>		1  same as "gj"
|g<End>|	g<End>		1  same as "g$"
|g<Home>|	g<Home>		1  same as "g0"
|g<LeftMouse>|	g<LeftMouse>	   same as <C-LeftMouse>
		g<MiddleMouse>	   same as <C-MiddleMouse>
|g<RightMouse>|	g<RightMouse>	   same as <C-RightMouse>
|g<Tab>|	g<Tab>		   go to last accessed tab page
|g<Up>|		g<Up>		1  same as "gk"
```

## Alternate formatters

[https://github.com/prdanelli/dotfiles/blob/main/neovim/lua/plugins/formatter.lua]

## `vim.nvim_create_user_command` completion for git branches

```lua
local function git_branch_complete(arglead, cmdline, cursorpos)
  -- Get the list of git branches
  local branches = vim.fn.systemlist('git branch --format="%(refname:short)"')
  -- Filter branches that start with the current argument lead
  local matches = vim.tbl_filter(function(branch)
    return vim.startswith(branch, arglead)
  end, branches)
  return matches
end
```

## vim.ui.input vimscript git branch completion

```lua
vim.api.nvim_exec2(
  [[
  fun! GitBranchComplete(ArgLead, CmdLine, CursorPos)
      return system('git branch --format="%(refname:short)" | grep "^' . a:ArgLead . '"')
  endfunction
  ]],
  { output = true }
)
local branch = vim.ui.input("Branch: ", {
  completion = "customlist,GitBranchComplete",
})
```

## Javascript snippets

- https://github.com/search?q=path%3A**%2Fnvim%2Fsnippets%2F**%2Fjavascript.json+async&type=code

- https://github.com/richban/system/blob/46efe696c3995e6c735e4285b301bdaba0be0864/dotfiles/config/nvim/snippets/javascript/javascript.json#L72

## Cmp plugins before switch to blink

- cmp-extended
- cmp.dap
- cmp.git

## modes

Help file [[/opt/homebrew/Cellar/neovim/0.10.3/share/nvim/runtime/doc/map.txt]]

There are seven sets of mappings

- For Normal mode: When typing commands.
- For Visual mode: When typing commands while the Visual area is highlighted.
- For Select mode: like Visual mode but typing text replaces the selection.
- For Operator-pending mode: When an operator is pending (after "d", "y", "c", etc.). See below: |omap-info|.
- For Insert mode. These are also used in Replace mode.
- For Command-line mode: When entering a ":" or "/" command.
- For Terminal mode: When typing in a |:terminal| buffer.

```help

*mapmode-x* *mapmode-s*
Some commands work both in Visual and Select mode, some in only one.  Note
that quite often "Visual" is mentioned where both Visual and Select mode
apply. |Select-mode-mapping|
NOTE: Mapping a printable character in Select mode may confuse the user.  It's
better to explicitly use :xmap and :smap for printable characters.  Or use
:sunmap after defining the mapping.

*mapmode-nvo* *mapmode-n* *mapmode-v* *mapmode-o* *mapmode-t*

There are seven sets of mappings
- For Normal mode: When typing commands.
- For Visual mode: When typing commands while the Visual area is highlighted.
- For Select mode: like Visual mode but typing text replaces the selection.
- For Operator-pending mode: When an operator is pending (after "d", "y", "c",
etc.).  See below: |omap-info|.
- For Insert mode.  These are also used in Replace mode.
- For Command-line mode: When entering a ":" or "/" command.
- For Terminal mode: When typing in a |:terminal| buffer.

Special case: While typing a count for a command in Normal mode, mapping zero
is disabled.  This makes it possible to map zero without making it impossible
to type a count with a zero.

*mapmode-nvo* *mapmode-n* *mapmode-v* *mapmode-o* *mapmode-t*

There are seven sets of mappings
- For Normal mode: When typing commands.
- For Visual mode: When typing commands while the Visual area is highlighted.
- For Select mode: like Visual mode but typing text replaces the selection.
- For Operator-pending mode: When an operator is pending (after "d", "y", "c",
etc.).  See below: |omap-info|.
- For Insert mode.  These are also used in Replace mode.
- For Command-line mode: When entering a ":" or "/" command.
- For Terminal mode: When typing in a |:terminal| buffer.

Special case: While typing a count for a command in Normal mode, mapping zero
is disabled.  This makes it possible to map zero without making it impossible
to type a count with a zero.

*mapmode-ic* *mapmode-i* *mapmode-c* *mapmode-l*
Some commands work both in Insert mode and Command-line mode, some not:

COMMANDS				                        MODES ~
                                        Insert  Command-line	Lang-Arg ~
:map!  :noremap!  :unmap!  :mapclear!	    yes	       yes	   -
:imap  :inoremap  :iunmap  :imapclear	    yes		-	   -
:cmap  :cnoremap  :cunmap  :cmapclear	     -	       yes	   -
:lmap  :lnoremap  :lunmap  :lmapclear	    yes*       yes*	  yes*

* If 'iminsert' is 1, see |language-mapping| below.

The original Vi did not have separate mappings for
Normal/Visual/Operator-pending mode and for Insert/Command-line mode.
Therefore the ":map" and ":map!" commands enter and display mappings for
several modes.  In Vim you can use the ":nmap", ":vmap", ":omap", ":cmap" and
":imap" commands to enter mappings for each mode separately.

*omap-info*
Operator-pending mappings can be used to define a movement command that can be
used with any operator.  Simple example: >
:omap { w
makes "y{" work like "yw" and "d{" like "dw".

To ignore the starting cursor position and select different text, you can have
the omap start Visual mode to select the text to be operated upon.  Example
that operates on a function name in the current line: >
onoremap <silent> F :<C-U>normal! 0f(hviw<CR>
The CTRL-U (<C-U>) is used to remove the range that Vim may insert.  The
Normal mode commands find the first '(' character and select the first word
before it.  That usually is the function name.

To enter a mapping for Normal and Visual mode, but not Operator-pending mode,
first define it for all three modes, then unmap it for
Operator-pending mode: >
:map    xx something-difficult
:ounmap xx

Likewise for a mapping for Visual and Operator-pending mode or Normal and
Operator-pending mode.
```
