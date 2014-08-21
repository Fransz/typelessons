ExamView = Backbone.View.extend
    typedStringTemplate: _.template '<%= shortenedString %><span class="<%= lastScore %>"><%= lastChar %></span>'

    initialize: () ->
        @listenTo @model, "change:testString", @renderTestString
        @model.trigger "change:testString"

        @listenTo @model, "change:lastChar", @showKey
        @listenTo @model, "change:lastChar", @renderTypedString

        # This is tedious; The key event cannot be bound to the views element, cause that doesnt receive the event,
        # So we bind it to the document with jQuery's bind, and make sure we can use this by using underscores bindAll
        _.bindAll @, 'processKey'
        $(document).bind 'keypress', @processKey


    # Shows our testString.
    # Event handler for change:testString event on this views model.
    #
    # @return void
    renderTestString: () ->
        @$("#teststring").html @model.get "testString"


    # Set a class on the last pressed key element, remove it after 200ms.
    # Event handler for change:lastKey event on this views model.
    #
    # @return void
    showKey: () ->
        # @TODO extend this for All Uppercase; enter;
        idMap =
            '-': "#keydash" '=': "#keyequal" ' ': "#keybackspace" '': "#keyenter" ';': "#keysemicolon"
            '\'': "#keysinglequote" '\\': "#keybackslash" ',': "#keycomma" '.': "#keydot" '/': "#keyslash"
            ' ': "#keyspace"

        key = @model.get "lastChar"
        id = if idMap[key] then idMap[key] else "#key#{key}"

        className = @model.get "lastScore"

        $(id).addClass(className)

        _f = () -> $(id).removeClass(className)
        setTimeout _f, 200


    # Shows our typedString, with the last character highlighted.
    # Event handler for change:lastKey event on this views model.
    #
    # @return void
    renderTypedString: () ->
        typedString = @model.get "typedString"
        shortenedString = typedString.slice 0, typedString.length - 1
        lastChar = @model.get "lastChar"
        lastScore = @model.get "lastScore"

        @$("#typedString").html @typedStringTemplate { shortenedString: shortenedString, lastChar: lastChar, lastScore: lastScore }


    # Let the model add a keystroke..
    # event handle for keyup events.
    #
    # @return void
    processKey: (evt) ->
        console.log String.fromCharCode evt.which
        @model.addKeyStroke String.fromCharCode evt.which

