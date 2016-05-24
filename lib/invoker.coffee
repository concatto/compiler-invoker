{File} = require 'atom'
spawn = require('child_process').spawn

module.exports =
class Invoker
  constructor: (@textFunction, @informationFunction) ->

  getExtension: (path) ->
    return path.substring(path.lastIndexOf('.') + 1)

  filterFiles: (directory, extension) ->
    files = (file for file in directory.getEntriesSync() when @getExtension(file.getPath()) == extension)
    return files

  getActiveDirectory: ->
    return new File(atom.workspace.getActiveTextEditor().getPath()).getParent()

  compile: =>
    @killProcess()

    directory = @getActiveDirectory()
    files = (file.getPath() for file in @filterFiles(directory, "cpp"));
    executable = directory.getPath() + "/" + directory.getBaseName()
    args = files.concat(['-o', executable, '-g', '-std=c++11'])

    compilerProgram = "g++"
    compiler = spawn(compilerProgram, args)
    compiler.stdout.on("data", (text) => @textFunction(text))
    compiler.stderr.on("data", (text) => @textFunction(text))
    compiler.on "exit", (code) =>
      @informationFunction("Compilation finished with code " + code + ".\n")
      if (code == 0)
        @exe = spawn(executable)
        @exe.stdout.on("data", @textFunction)
        @exe.stderr.on("data", @textFunction)
        @exe.on "exit", (exeCode, signal) =>
          @exe = undefined
          outcome = if exeCode? then ("code " + exeCode) else ("signal " + signal)
          @informationFunction("Execution finished with " + outcome + ".\n")

    @informationFunction("Starting process \"" + compilerProgram + "\" ...\n")

  writeToProcess: (data) =>
    if @exe?
      @textFunction(data)
      @exe.stdin.write(data + "\n")
      @textFunction("\n")

  killProcess: =>
    @exe?.kill()
