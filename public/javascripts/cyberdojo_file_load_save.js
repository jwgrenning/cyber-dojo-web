
var current_filename = false;

function saveCurrentFile() 
{
  if (current_filename) 
  {
    var editor = $j('#editor');
    fileContent(current_filename).setAttribute('value', editor.val());
    fileCaretPos(current_filename).setAttribute('value', editor.caretPos());
    fileScrollLeft(current_filename).setAttribute('value', editor.scrollLeft());
    fileScrollTop(current_filename).setAttribute('value', editor.scrollTop());
  }
}

function loadFile(filename) 
{
  var caret_pos = fileCaretPos(filename).getAttribute('value');
  var scroll_top  = fileScrollTop(filename).getAttribute('value');
  var scroll_left = fileScrollLeft(filename).getAttribute('value');
  var code = fileContent(filename).getAttribute('value');

  var editor = $j('#editor');
  editor.val(code);
  editor.caretPos(caret_pos);
  editor
    .scrollTop(scroll_top)
    .scrollLeft(scroll_left);
  
  selectFileInFileList(filename);
}

function selectFileInFileList(filename) 
{
  $('radio_' + filename).checked = true;
  $('current_filename').setAttribute('value', filename);
  current_filename = filename;
  if (filename === 'output')
    $j('#editor').attr('readonly', 'true');
  else
    $j('#editor').removeAttr('readonly');
}

function fileContent(filename) 
{
  return $('file_content_for_' + filename);
}

function fileCaretPos(filename) 
{
  return $('file_caret_pos_for_' + filename);
}

function fileScrollLeft(filename)
{
  return $('file_scroll_left_for_' + filename);
}

function fileScrollTop(filename)
{
  return $('file_scroll_top_for_' + filename);
}


