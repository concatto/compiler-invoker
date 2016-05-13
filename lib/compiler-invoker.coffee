CompilerInvokerView = require './compiler-invoker-view'
Invoker = require './invoker'
{CompositeDisposable} = require 'atom'

module.exports = ConsoleView =
  consumeToolBar: (toolBar) ->
    @toolBar = toolBar('compiler-invoker');
    @toolBar.addButton
      icon: 'coffee'
      callback: 'compiler-invoker:compile-and-run'
      tooltip: 'Compile and Run'
      iconset: 'ion'

  activate: (state) ->
    @compilerInvokerView = new CompilerInvokerView(state.compilerInvokerViewState)
    @invoker = new Invoker()
    @modalPanel = atom.workspace.addBottomPanel(item: @compilerInvokerView.getElement(), visible: true)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'compiler-invoker:toggle': => @toggle()
      'compiler-invoker:compile-and-run': => @compileAndRun()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @compilerInvokerView.destroy()
    @toolBar?.removeItems();

  serialize: ->
    compilerInvokerViewState: @compilerInvokerView.serialize()

  toggle: ->
    console.log 'CompilerInvoker was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  compileAndRun: =>
    @invoker.compile (output) =>
      @compilerInvokerView.appendText(output)
