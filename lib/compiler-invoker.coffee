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

    @toolBar.addButton
      icon: 'backspace'
      callback: 'compiler-invoker:clear-console'
      tooltip: 'Clear console'
      iconset: 'ion'

    @toolBar.addButton
      icon: 'nuclear'
      callback: 'compiler-invoker:kill-process'
      tooltip: 'Kill process'
      iconset: 'ion'

  activate: (state) ->
    @compilerInvokerView = new CompilerInvokerView(state.compilerInvokerViewState)
    @invoker = new Invoker ((text) => @compilerInvokerView.appendText(text)), \
                           ((info) => @compilerInvokerView.appendInformation(info))

    @compilerInvokerView.onInput(@invoker.writeToProcess)
    @modalPanel = atom.workspace.addBottomPanel(item: @compilerInvokerView.getElement(), visible: true)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'compiler-invoker:toggle': => @toggle()
      'compiler-invoker:compile-and-run': => @invoker.compile()
      'compiler-invoker:clear-console': => @compilerInvokerView.clearText()
      'compiler-invoker:kill-process': => @invoker.killProcess()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @compilerInvokerView.destroy()
    @toolBar?.removeItems();

  serialize: ->
    compilerInvokerViewState: @compilerInvokerView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
