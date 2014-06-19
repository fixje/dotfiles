if !has('python')
  finish
endif

if !exists("g:vimux_pyutils_use_tslime")
  let g:vimux_pyutils_use_tslime=0
endif

python << endpython
import re

# http://stackoverflow.com/questions/2695443/can-you-access-registers-from-python-functions-in-vim
def set_register(reg, value):
  vim.command("let @%s='%s'" % (reg, value.replace("'","''")))

def send_to_tmux(lines):
  # Global variable can be used to switch between vimux and tslime
  if vim.eval("g:vimux_pyutils_use_tslime") == "1":
    vim.command(':call Send_to_Tmux("\%cpaste\n")')
    # Send by chunk of 20 lines
    lines_step = 20
    for i in xrange(0, len(lines), lines_step):
      lines_chunk = lines[i:i+lines_step]
      l = "\n".join(lines_chunk)
      l = l.replace('\\', '\\\\')
      l = l.replace('"', '\\"')

      vim.command("echo 'sending to tslime length : %i'"%len(l))
      vim.command(':call Send_to_Tmux("%s\\n")' % l)
      # TODO: This is needed on some systems (OSX) to avoid getting scrambled
      # output. But this is a bit of an ugly fix

      # Sleep long enough to let the cpaste finish
      vim.command(':sleep 200m')

    vim.command(':call Send_to_Tmux("\n--\n")')
  else:
    l = "\n".join(lines)
    set_register('+', l)
    vim.command(':call VimuxRunCommand("%paste\n", 0)')


def run_tmux_python_chunk():
  """
  Will copy/paste the currently selected block into the tmux split.
  The code is unindented so the first selected line has 0 indentation
  So you can select a statement from inside a function and it will run
  without python complaining about indentation.
  """
  r = vim.current.range
  #vim.command("echo 'Range : %i %i'" % (r.start, r.end))
  # Count indentation on first selected line
  firstline = vim.current.buffer[r.start]
  nindent = 0
  for i in xrange(0, len(firstline)):
    if firstline[i] == ' ':
      nindent += 1
    else:
      break
  # vim.command("echo '%i'" % nindent)

  # Shift the whole text by nindent spaces (so the first line has 0 indent)
  lines = vim.current.buffer[r.start:r.end+1]
  if nindent > 0:
    pat = '\s'*nindent
    lines = [re.sub('^%s'%pat, '', l) for l in lines]

  # Add empty newline at the end
  lines.append('\n\n')

  send_to_tmux(lines)
  # Now, there are multiple solutions to copy that to tmux

  # 1. With cpaste
  #vim.command(':call VimuxRunCommand("%cpaste\n", 0)')
  #vim.command(':call VimuxRunCommand("%s", 0)' % lines)
  #vim.command(':call VimuxRunCommand("\n--\n", 0)')

  # 2. With cpaste (better, only one command, but rely on system clipboard)

  # Move cursor to the end of the selection
  vim.current.window.cursor=(r.end+1, 0)

def run_tmux_python_cell(restore_cursor=False):
  """
  This is to emulate MATLAB's cell mode
  Cells are delimited by ##. Note that there should be a ## at the end of the
  file
  The :?##?;/##/ part creates a range with the following
  ?##? search backwards for ##
  Then ';' starts the range from the result of the previous search (##)
  /##/ End the range at the next ##
  See the doce on 'ex ranges' here :
  http://tnerual.eriogerg.free.fr/vimqrc.html
  Then, we simply call run_tmux_python_chunk that will run the range
  of the current buffer
  """
  if restore_cursor:
    # Save cursor position
    (row, col) = vim.current.window.cursor

  # Run chunk on cell range
  vim.command(':?##?;/##/ :python run_tmux_python_chunk()')

  if restore_cursor:
    # Restore cursor position
    vim.current.window.cursor = (row, col)


def run_tmux_python_buffer(restore_cursor=False):
  """
  run the whole buffer
  """
  if restore_cursor:
    # Save cursor position
    (row, col) = vim.current.window.cursor

  # Run chunk on cell range
  vim.command(':% :python run_tmux_python_chunk()')

  if restore_cursor:
    # Restore cursor position
    vim.current.window.cursor = (row, col)

endpython

