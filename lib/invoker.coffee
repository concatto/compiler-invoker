{File} = require 'atom'
spawn = require('child_process').spawn

module.exports =
class Invoker
  getExtension: (path) ->
    return path.substring(path.lastIndexOf('.') + 1)

  filterFiles: (directory, extension) ->
    files = (file for file in directory.getEntriesSync() when @getExtension(file.getPath()) == extension)
    return files

  getActiveDirectory: ->
    return new File(atom.workspace.getActiveTextEditor().getPath()).getParent()

  compile: (outputFunction) ->
    directory = @getActiveDirectory()
    files = (file.getPath() for file in @filterFiles(directory, "cpp"));
    executable = directory.getPath() + "/" + directory.getBaseName()
    args = [files.join(" "), '-o', executable, '-g', '-std=c++11']

    compiler = spawn("g++", args)
    compiler.stdout.on("data", outputFunction)
    compiler.stderr.on("data", outputFunction)
    compiler.on "exit", (code) ->
      if (code == 0)
        exe = spawn(executable)
        exe.stdout.on("data", outputFunction)
        exe.stderr.on("data", outputFunction)
