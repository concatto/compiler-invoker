{File} = require 'atom'


module.exports =
class Utils
  @getExtension: (path) ->
    return path.substring(path.lastIndexOf('.') + 1)

  @filterFiles: (directory, extension) ->
    files = (file for file in directory.getEntriesSync() when @getExtension(file.getPath()) == extension)
    return files

  @getActiveDirectory: ->
    return new File(@getActiveFile()).getParent()

  @getActiveFile: ->
    return atom.workspace.getActiveTextEditor().getPath()

  @getFilename: (path, removeExtension) ->
    separator = if process.platform == "win32" then '\\' else '/'
    path = path.substring(path.lastIndexOf(separator) + 1);
    if (removeExtension)
      path = path.substring(0, path.lastIndexOf('.'));

    return path
