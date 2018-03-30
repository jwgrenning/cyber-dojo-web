/*global jQuery,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.fileContentFor = function(filename) {
    return cd.id('file_content_for_' + filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.fileDiv = function(filename) {
    return cd.id(filename + '_div');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.currentFilename = function() {
    // I tried changing this to...
    //   return $('input:radio[name=filename]:checked').val();
    // (which would remove the need for the file
    //    app/views/kata/_current_filename.html.erb)
    // This worked on Firefox but not on Chrome.
    // The problem seems to be that in Chrome the javascript handler
    // function invoked when the radio button filename is clicked sees
    //    $('input:radio[name=filename]:checked')
    // as having _already_ changed. Thus you cannot retrieve the
    // old filename.
    return $('#current-filename').val();
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.filenameAlreadyExists = function(filename) {
    return cd.inArray(filename, cd.filenames());
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  const isSourceFile = function(filename) {
    var match = false;
    $.each(cd.extensionFilenames(), function(_, extension) {
      // Shell test frameworks (eg shunit2) use .sh as their
      // filename extension but we don't want cyber-dojo.sh
      // in the hiFilenames() above output in the filename-list.
      if (filename.endsWith(extension) && filename != 'cyber-dojo.sh') {
        match = true;
      }
    });
    return match;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.hiFilenames = function(filenames) {
    // Controls which filenames appear at the
    // top of the filename-list, above 'output'
    //
    // Used in three places.
    // 1. kata/edit page to help show filename list
    // 2. kata/edit page in alt-j alt-k hotkeys
    // 3. review/show page/dialog to help show filename list
    //
    var hi = [];
    $.each(filenames, function(_, filename) {
      if (isSourceFile(filename) && filename != 'output') {
        hi.push(filename);
      }
    });
    hi.sort();
    return hi;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.loFilenames = function(filenames) {
    // Controls which filenames appear at the
    // bottom of the filename list, below 'output'
    //
    // Used in three places.
    // 1. kata/edit page to help show filename-list
    // 2. kata/edit page in alt-j alt-k hotkeys
    // 3. review/show page/dialog to help show filename-list
    //
    var lo = [];
    $.each(filenames, function(_, filename) {
      if (!isSourceFile(filename) && filename != 'output') {
        lo.push(filename);
      }
    });
    lo.sort();
    return lo;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.sortedFilenames = function(filenames) {
    // Controls the order of files in the filename-list
    // Used in two places
    //
    // 1. kata/edit page to help show filename-list
    // 2. review/show page/dialog to help show filename-list
    //
    return [].concat(cd.hiFilenames(filenames), ['output'], cd.loFilenames(filenames));
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.rebuildFilenameList = function() {
    var filenames = cd.filenames();
    var filenameList = $('#filename-list');
    filenameList.empty();
    $.each(cd.sortedFilenames(filenames), function(_, filename) {
      filenameList.append(cd.makeFileListEntry(filename));
    });
    return filenames;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.filenames = function() {
    // Gets the filenames when on a kata/edit page.
    // The review/show page/dialog has to collect its filenames
    // in its own way.
    var prefix = 'file_content_for_';
    var filenames = [ ];
    $('textarea[id^=' + prefix + ']').each(function(_) {
      var id = $(this).attr('id');
      var filename = id.substr(prefix.length, id.length - prefix.length);
      filenames.push(filename);
    });
    return filenames;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeFileListEntry = function(filename) {
    var div = $('<div>', {
      'class': 'filename',
      id: 'radio_' + filename,
      text: filename
    });
    if (cd.inArray(filename, cd.highlightFilenames())) {
      div.addClass('highlight');
    }
    //if (cd.inArray(filename, cd.lowlightFilenames())) {
    //  div.addClass('lowlight');
    //}
    div.click(function() { cd.loadFile(filename); });
    return div;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.makeNewFile = function(filename, content) {
    var div = $('<div>', {
      'class': 'filename_div',
      id: filename + '_div'
    });
    var table = $('<table>');
    var tr = $('<tr>');
    var td1 = $('<td>');
    var lines = $('<div>', {
      'class': 'line_numbers',
      id: filename + '_line_numbers'
    });
    var td2 = $('<td>');
    var text = $('<textarea>', {
      'class': 'file_content',
      'spellcheck': 'false',
      'data-filename': filename,
      name: 'file_content[' + filename + ']',
      id: 'file_content_for_' + filename
      //
      //wrap: 'off'
      //
    });
    // For some reason, setting wrap cannot be done as per the
    // commented out line above... when you create a new file in
    // FireFox 17.0.1 it still wraps at the textarea width.
    // So instead I do it like this, which works in FireFox?!
    text.attr('wrap', 'off');

    text.val(content);
    td1.append(lines);
    tr.append(td1);
    td2.append(text);
    tr.append(td2);
    table.append(tr);
    div.append(table);

    cd.bindHotKeys(text);

    return div;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.testFilenameIndex = function(filenames) {
    // When starting and in file-knave navigation
    // the current file is sometimes not present.
    // (eg the file has been renamed/deleted).
    // When this happens, try to select a test file.
    var i,parts,filename;
    for (i = 0; i < filenames.length; i++) {
      parts = filenames[i].toLowerCase().split('/');
      filename = parts[parts.length - 1];
      if (filename.search('test') !== -1) {
        return i;
      }
    }
    return 0;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.newFileContent = function(filename, content) {
    var newFile = cd.makeNewFile(filename, content);
    $('#visible-files-container').append(newFile);
    cd.bindLineNumbers(filename);
    cd.rebuildFilenameList();
    cd.loadFile(filename);
    cd.switchEditorToCodeMirror(filename);
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.deleteFile = function(filename) {
    cd.fileDiv(filename).remove();
    var filenames = cd.rebuildFilenameList();
    var i = cd.testFilenameIndex(filenames);
    cd.loadFile(filenames[i]);
  };

  return cd;
})(cyberDojo || {}, jQuery);
