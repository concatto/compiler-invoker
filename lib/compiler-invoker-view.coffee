module.exports =
class CompilerInvokerView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('compiler-invoker')

    # Create message element
    @message = document.createElement('div')
    @message.classList.add('message', 'native-key-bindings')
    @element.appendChild(@message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  appendText: (text) ->
    @message.textContent += text
