App = App or {}

App.NewTaskView = Backbone.View.extend
    el: "#newtask"

    rowTemplate: _.template @$("#newtaskrowtemplate").html()
    inputTemplate: _.template @$("#newtaskinputtemplate").html()
    errorTemplate: _.template @$("#newtaskerrortemplate").html()

    events:
        "keypress .letter" : "addLetter"
        "change .weight" : "addWeight"
        "click .delete" : "deleteLetter"
        "click #newtaskevenweights" : "fillEvenWeights"
        "click #newtaskcancel" : "cancel"
        "click #newtaskok" : "submit"

    # flag signs that some weight was filled in by the user.
    evenWeights: true
    

    initialize: () ->
        @listenTo @model, "invalid", @renderError
        @render()


    # Add the given letter to our model, 
    # disable the letter input, focus the weight input or show evenweights
    #
    # @param evt The event
    # #return void
    addLetter: (evt) ->
        lElm = $(evt.target)
        wElm = lElm.closest(".letterweightpair").children(".weight")

        # @see http://stackoverflow.com/questions/5566937/javascript-map-array-with-fromcharcode-character-length
        letter = String.fromCharCode(evt.which)

        if @model.addLetter(letter)
            lElm.val(letter)
            lElm.prop 'disabled', true

            if @evenWeights
                @model.evenWeights()
                @render()
            else
                (wElm.get())[0].focus()
                wElm.val('')

        return false


    # Set the custom weight flag, reset the NewModel.
    #
    # @param evt The event
    # #return void
    addWeight: (evt) ->
        elm = $(evt.target)
        w = elm.val()
        l = elm.closest(".letterweightpair").children(".letter").val()

        @evenWeights = false
        if @model.addWeight l, w
            @render()

        return false

    # deletes the letter from the NewTask
    #
    # @param evt The event
    # @return void
    deleteLetter: (evt) ->
        elm = $(evt.target)
        l = elm.closest(".letterweightpair").children(".letter").val()

        if @model.deleteLetter l
            @render()

        return false

    # cancel the creation of a new Task. We let our AppView know with an event.
    #
    # @param evt
    # @return void
    cancel: (evt) ->
        @undelegateEvents()
        @trigger "cancelNewTask"
        return false

    submit: () ->
        if @model.isValid()
            ls = _.clone(@model.get "letters")
            ls[" "] = ls["space"]
            delete ls["space"]
            @trigger "submitNewTask", ls

        return false

    fillAutoLetters: () ->
        # let the tasksCollection come up with an array of letters, weight pairs
        # fill in

    fillEvenWeights: () ->
        @evenWeights = true
        @model.evenWeights()
        @render()

        return false

    # render all letter and weight pairs of the NewModel, 4 in a row.
    # All letters inputs will be disabled; the last empty letter input will receive focus.
    # The "space" letter is outputed first on a seperate row; It should always be present in the letters attribute
    #
    # @return void
    render: () ->
        error = @$el.find(".newtaskerror")
        error.remove()

        rowsElement = @$ ".letterweightpairrows"
        rowsElement.html("")

        n = 2                                               # nr inputs on a row.
        letters_ = _.clone(@model.get("letters"))

        # first render data for the "space" character in its own row, with its own style
        space = letters_["space"]
        delete letters_["space"]

        row = $(@rowTemplate({}).trim())
        row.append @inputTemplate letter: "space", weight: space
        row.find(".weight").prop 'disabled', true
        row.find(".delete").remove()
        rowsElement.append row


        # All other letters should be rendered in order.
        ls = _.pairs(letters_)                              # letter weight tuppels
        ls.sort()


        # render rows with n letters
        while ls.length > 0
            row = $(@rowTemplate({}).trim())

            # n is 2, or nr of left if nr of left < 2
            n = if n > ls.length then ls.length else n
            ls_ = ls[0 .. n - 1]
            ls = ls[n ..]

            row.append @inputTemplate letter: p[0], weight: p[1] for p in ls_
            rowsElement.append row

        # add a new input, maybe in a new row.
        if n is 2
            row = $(@rowTemplate({}).trim())
            rowsElement.append row

        inp = $(@inputTemplate({letter: "", weight: ""}).trim())
        inp.find(".letter").prop 'disabled', false
        row.append inp
        (inp.find(".letter").get())[0].focus()


    renderError: (model, error) ->
        @$el.find(".newtaskerror").remove()
        @$el.append @errorTemplate error: error
