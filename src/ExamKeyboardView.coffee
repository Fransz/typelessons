ExamKeyboardView = Backbone.View.extend
    initialize: () ->
        @listenTo @model, "change:lastChar", @showKey

        # This is tedious; The key event cannot be bound to this views element, cause that doesnt receive the event,
        # So we bind it to the document with jQuery's bind, and make sure we can use this by using underscores bindAll
        _.bindAll @, 'processKey'
        $(document).bind 'keypress', @processKey

    # event handle for keyup events.
    #
    # @return void
    processKey: (evt) ->
        @model.addKeyStroke String.fromCharCode evt.which

    # Set a class on the last pressed key element, remove it after 200ms.
    # Event handler for change:position event on this views model.
    #
    # @return void
    showKey: () ->
        id = "#key#{@model.get "lastChar"}"
        className = @model.get "lastScore"

        $(id).addClass(className)

        _f = () -> $(id).removeClass(className)
        setTimeout _f, 200
