ExamView = Backbone.View.extend
    # The typed strings last character is marked.
    typedStringTemplate: _.template '<%= shortenedString %><span class="<%= lastScore %>"><%= lastChar %></span>'

    # The views element already exists.
    el: "#exam"

    # Pointer to function used for increasing ticks.
    ticker: null

    # Ticks the exam took
    ticks: 0

    # The taskModel for which we created this exam.
    task: null

    initialize: (args) ->
        @task = args.task

        @listenTo @model, "change:testString", @renderTestString
        @model.trigger "change:testString"

        @listenTo @model, "change:lastChar", @showKey
        @listenTo @model, "change:lastChar", @renderTypedString
        @listenTo @model, "change:lastChar", @renderScores
        @listenTo @model, "change:completed", @examCompleted

        @$('#completed').hide()

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
            '-': "#keydash"
            '=': "#keyequal"
            ' ': "#keybackspace"
            '': "#keyenter"
            ';': "#keysemicolon"
            '\'': "#keysinglequote"
            '\\': "#keybackslash"
            ',': "#keycomma"
            '.': "#keydot"
            '/': "#keyslash"
            ' ': "#keyspace"
            '[': "#keyblockopen"
            ']': "#keyblockclose"
            '`': "#keybackquote"

        key = @model.get "lastChar"
        id = if idMap[key] then idMap[key] else "#key#{key}"

        className = @model.get "lastScore"

        $(id).addClass(className)

        _f = () -> $(id).removeClass(className)
        setTimeout _f, 200


    # Shows our typedString, with the last character highlighted.
    # Event handler for change:lastKey event on this views model.
    #
    # @param mark  wheter the last character should be marked with its score
    # @return void
    renderTypedString: (mark=true) ->
        typedString = @model.get "typedString"
        last = typedString.length - 1
        shortenedString = typedString[0 ... last]
        lastChar = typedString[last]
        if mark
            lastScore = @model.get "lastScore"

        @$("#typedstring").html @typedStringTemplate { shortenedString: shortenedString, lastChar: lastChar, lastScore: lastScore }


    # Show the last scores
    # Event handler for change:lastKey event on this views model.
    #
    # @return void
    renderScores: () ->
        scores = @model.sumScore()
        @$("#scores #pass").html scores.pass
        @$("#scores #fail").html scores.fail


    
    # Let the model add a keystroke..
    # event handle for keyup events.
    #
    # @return void
    processKey: (evt) ->
        if not @ticker then @setTicker()
        # evt.stopPropagation()
        evt.preventDefault()
        @model.addKeyStroke String.fromCharCode evt.which

    # A ticker for keeping time
    #
    # @return void
    setTicker: () ->
        [m, s] = [0, 0]
        e = @$ "#scores #time"
        @ticks = 0

        _ticker = () =>
            e.html "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"
            if (++s == 60)
                s = 0
                m++
            @ticks++

        _ticker()
        @ticker = setInterval _ticker, 1000

    # clears the timeticker.
    #
    # @return Number The tick count.
    clearTicker: () ->
        clearInterval @ticker

    # Mark he model for this exam as completed, clean up our exam.
    # eventhandler for change:completed
    #
    # @return void
    examCompleted: () ->
        @clearTicker()
        @stopListening()
        $(document).unbind 'keypress'

        @renderTypedString false
        @showKey()
        @renderScores()
        @$('#completed').show()

        @model.set "duration", @ticks
        @task.completeExam @model
