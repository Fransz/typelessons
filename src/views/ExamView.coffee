App = App or {}

App.ExamView = Backbone.View.extend
    # The views element already exists.
    el: "#exam"

    # Pointer to function used for increasing ticks.
    ticker: null

    # Ticks the exam took
    ticks: 0

    # The taskModel for which we created this exam.
    task: null

    # The remaining string to be typed
    toBeTypedString: ""


    initialize: (args) ->
        @task = args.task

        # Show our testString.
        @toBeTypedString = @model.get("testString")
        @$("#teststring #content").html @toBeTypedString
        @$("#teststring").css visibility: "visible"

        @listenTo @model, "change:lastChar", @showKey
        @listenTo @model, "change:lastChar", @renderScores
        @listenTo @model, "change:lastChar", @renderToBeTypedString
        @listenTo @model, "change:completed", @examCompleted

        # This is tedious; The key event cannot be bound to the views element, cause that doesnt receive the event,
        # So we bind it to the document with jQuery's bind, and make sure we can use this by using underscores bindAll
        _.bindAll @, 'processKey'
        $(document).bind 'keypress', @processKey


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


    # Shows whats left of the string to be typed.
    #
    # @return void
    renderToBeTypedString: () ->
        @toBeTypedString = @toBeTypedString[1 ...]

        # A leading (or the first) space should be replaced by a &nbsp;
        @$("#teststring #content").html @toBeTypedString.replace(' ', "&nbsp;")

        className = @model.get "lastScore"
        @$("#teststring").addClass(className)

        _f = () -> @$("#teststring").removeClass(className)
        setTimeout _f, 200
    

    # Show the last scores
    # Event handler for change:lastKey event on this views model.
    #
    # @return void
    renderScores: () ->
        scores = @model.sumScore()
        @$("#scores #pass .score").html scores.pass
        @$("#scores #fail .score").html scores.fail


    
    # Let the model add a keystroke..
    # event handle for keyup events.
    #
    # @return void
    processKey: (evt) ->
        if not @ticker then @setTicker()
        evt.preventDefault()
        @model.addKeyStroke String.fromCharCode evt.which

    # A ticker for keeping time
    #
    # @return void
    setTicker: () ->
        [m, s] = [0, 0]
        e = @$ "#scores #time .score"
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

        @renderToBeTypedString()
        @showKey()
        @renderScores()

        @$("#teststring #content").html "&nbsp;"
        @$("#teststring").css visibility: "hidden"

        @model.set "time", @ticks - 1
        @task.completeExam @model
