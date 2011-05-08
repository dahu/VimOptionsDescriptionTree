" Description's dict {{{1
let s:option_settings = {
      \'cpoptions' : {
      \  'a' : ':read updates alternative file name',
      \  'A' : ':write updates alternative file name',
      \  'b' : '\| in a map command recognised as end of map',
      \  'B' : 'a backslash has no special meaning in mappings',
      \  'c' : 'searching continues at the end of the match at the cursor position',
      \  'C' : 'don''t concatenate sourced lines starting with a backslash',
      \  'd' : 'using ./ in ''tags'' means using tags file in current directory',
      \  'e' : 'automatically add <CR> to the last line when using :@r',
      \  'E' : 'force errors when operators used on empty regions',
      \  'f' : ':read command updates current file name',
      \  'F' : ':write command updates current file name',
      \  'g' : ':edit without argument goes to line 1',
      \  'H' : 'I on line with only blanks inserts before last blank',
      \  'i' : 'interrupting reading of a file will leave it modified',
      \  'I' : 'don''t delete autoindent after moving cursor up or down',
      \  'j' : 'only add two spaces after a . when joining lines',
      \  'J' : 'sentences defined as having two spaces after . ! and ?',
      \  'k' : 'disable recognition of raw key codes in mappings',
      \  'K' : 'don''t wait for a key code to complete when it is halfway through a mapping',
      \  'l' : 'backslash in a [] range taken literally',
      \  'L' : 'count a <Tab> as two characters (when ''list'' set) instead of normal <Tab> behaviour',
      \  'm' : 'wait half a second for showmatch',
      \  'M' : 'ignore backslashes when matching parenthesis (vi compatible)',
      \  'o' : 'line offset to search command is not remembered for next search',
      \  'O' : 'Don''t complain if a file is being overwritten',
      \  'p' : 'vi compatible lisp indenting',
      \  'P' : ':write command that appends to a file will set current file name if unnamed and ''F'' flag also set',
      \  'q' : 'when joining multiple lines, leave cursor where it would be when joining two lines',
      \  'r' : 'redo command uses / to repeat a search command instead of actual search string',
      \  'R' : 'remove marks from filtered lines',
      \  's' : 'set buffer options when entering the first time (default)',
      \  'S' : 'set buffer options always when entering a buffer (vi compatible)',
      \  't' : 'tag search pattern changes last used search pattern',
      \  'u' : 'undo is vi compatible',
      \  'v' : 'backspaced characters remain visible in insert mode',
      \  'w' : 'cw only changes one blank not all until next word',
      \  'W' : 'don''t overwrite a read-only file',
      \  'x' : '<esc> on command-line executes instead of abandons',
      \  'X' : '<count>R replaced text deleted only once',
      \  'y' : '. redoes yanks',
      \  'Z' : ':w! with ''readonly'' set doesn''t reset ''readonly''',
      \  '!' : 'use last-used external command when filtering instead of last-used -filter- command',
      \  '$' : 'when changing a line put a $ at the end of the line',
      \  '%' : 'use vi compatible matching for the % command',
      \  '-' : 'fail if a vertical movement command goes above first or below last line',
      \  '+' : '":write file" always resets the ''modified'' flag of the buffer',
      \  '*' : ':* == :@',
      \  '<' : 'disable recognition of <> form key codes, like <Tab>',
      \  '>' : 'put a line break before appended text when appending to a register',
      \  '#' : '(posix) disable <count> for "D", "o" and "O"',
      \  '&' : '(posix) :preserve keeps the loaded buffer swap files when exiting normally',
      \  '\' : '(posix) backslash in a [] range in a search pattern is taken literally',
      \  '/' : '(posix) % in replacement string of a :substitute uses previous replacement string',
      \  '{' : '(posix) { and } commands also stop at the "{" character',
      \  '.' : '(posix) :cd and :chdir fail if current buffer is modified (unnecessary in Vim)',
      \  '|' : '(posix) $LINES and $COLUMNS environment variables override system-queried values',
      \},
      \}

" Options {{{1
let s:opts = {
  \ 'comment_leader' : '":-D',
  \ 'comment_trailer': '',
  \ 'actionable_line': '^\s*:\?set\?\s\+\S\+\s*=\s*\S',
  \ 'tree_line'      : '^\s*":-D\s\+\%(|\|`\)',
  \ 'tree_vert_line' : '|',
  \ 'tree_line_bend' : 'l',
  \ 'tree_horz_line' : '-',
  \ 'tree_horz_min'  : 2,
  \ 'tree_horz_sep'  : ' ',
  \}

function! OptionsCommentTree(line)
  let l:line = a:line
  if line !~ s:opts['actionable_line']
    "Not an option line... skip
    return
  endif
  let [l:indent, l:settings_gap] = map(matchlist(line, '^\(\s*\)\(:\?set\s*\S\+\s*=\s*\)')[1:2], 'strlen(v:val)')
  let l:settings = matchlist(line, '^\s*:\?set\s*\S\+\s*=\s*\(.*\)')[1]
  echo indent . ' ' . settings_gap
  let settings_gap -= 1
  let l:comment_line = repeat(' ', indent) . s:opts['comment_leader'] . repeat(' ', settings_gap)
  " iterate settings and create description tree
  let l:vert_count = len(settings)
  let l:cnt = 0
  for o in reverse(split(settings, '\zs'))
    let l:verts = repeat('|', vert_count - cnt - 1) . 'l'
    let l:desc_line = comment_line . verts . '-- '. s:option_settings['cpoptions'][o]
    call append(line('.') + cnt, desc_line)
    let cnt += 1
  endfor
endfunction

function! RemoveTree(line) "{{{1
  if getline(a:line) !~ s:opts['actionable_line']
    "Not an option line... skip
    return
  endif
  let end = a:line
  while getline(end + 1) =~ '\m\C'.s:opts['tree_line']
    let end += 1
  endwhile
  if end == a:line
    return
  endif
  exec (a:line + 1).','.end.'d'
endfunction

command! -bar OptionTree silent call RemoveTree(line('.'))|silent call OptionsCommentTree(line('.'))
finish "{{{1

" call it on an options line (later we can do this for all lines in a range) with:
" call OptionsCommentTree(getline('.'))

" Don't operate on commented lines:
"set cpoptions=aABceFsmq
"    set cpoptions=aABceFsmq
set cpoptions=aABceFsmq

    set cpoptions=aABceFsmq
