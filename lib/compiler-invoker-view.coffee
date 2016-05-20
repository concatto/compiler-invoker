module.exports =
class CompilerInvokerView
  constructor: (serializedState) ->
    @messageShown = false

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('compiler-invoker')

    @messageControl = document.createElement('div')
    @messageControl.classList.add('message-control')
    @messageControl.textContent = "Toggle"

    @messageControl.addEventListener 'click', () =>
      @toggleMessage()

    # Create message element
    @message = document.createElement('textarea')
    @message.classList.add('message', 'hidden', 'native-key-bindings')
    @message.setAttribute('readonly', 'readonly');
    @element.appendChild(@messageControl)
    @element.appendChild(@message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  toggleMessage: ->
    if (@messageShown)
      @message.classList.add('hidden')
    else
      @message.classList.remove('hidden')

    @messageShown = !@messageShown

  appendText: (text) ->
    @message.textContent += text
    @message.scrollTop = @message.scrollHeight

  clearText: ->
    @message.textContent = ''
