App = App or {}

App.NewTaskView = Backbone.View.extend
    el: "#newtask"

    rowTemplate: _.template @$("#newmodelrowtemplate").html()
    inputTemplate: _.template @$("#newmodelinputtemplate").html()
    errorTemplate: _.template @$("#newmodelerrortemplate").html()
    spaceHtml: @$ "#newmodelspacetemplate"

    events:
        "keypress .letter" : "addLetter"
        "change .weight" : "addWeight"

    # flag signs that some weight was filled in by the user.
    customWeights: false
    

    initialize: () ->
        # @listenTo @model, "change:letters", @render
        @listenTo @model, "invalid", @renderError
        # @model.set "letters", { "a": 1}
        # @model.set "letters", { "e": 1, "f": 2, "g": 3, "h": 4,  "a": 1, "b": 2, "c": 3, "d": 4}
        @render()


    # Add the given letter to our model, disable the letter input, focus the weight input
    #
    # @param evt The event
    # #return void
    addLetter: (evt) ->
        lElm = $(evt.target)
        letter = String.fromCharCode evt.which

        if @model.addLetter(letter)
            lElm.val(letter)
            lElm.prop 'disabled', true
            wElm = lElm.closest("#letterweightpair").children(".weight")
            (wElm.get())[0].focus()


    # Set the custom weight flag, reset the NewModel.
    #
    # @param evt The event
    # #return void
    addWeight: (evt) ->
        elm = $(evt.target)
        w = elm.val()
        l = elm.closest("#letterweightpair").children(".letter").val()

        @customWeights = true
        if @model.addWeight l, w
            @render()

    cancel: () ->
        # clear all letters and weights
        # delete view model

    submit: () ->
        # validate weights
        # if pass create new model
        # if fail error message

    autoLetters: () ->
        # let the tasksCollection come up with an array of letters, weight pairs
        # fill in

    autoWeights: () ->
        # let the newTaskModel come up with an array of letter, weight pairs
        # fill in

    # render all letter and weight pairs of the NewModel, 4 in a row.
    # all letters inputs will be disabled; the last empty letter input will receive focus.
    #
    # @return void
    render: () ->
        error = @$el.find(".error")
        error.remove()

        console.log "rendering"
        n = 4                                               # nr inputs on a row.
        ls = _.pairs(@model.get "letters")                  # letter weight tuppels

        rowsElement = @$ "#rows"
        rowsElement.html @spaceHtml

        while ls.length > 0
            row = $(@rowTemplate({}).trim())

            # n is 4, or nr of left if nr of left < 4
            n = if n > ls.length then ls.length else n
            ls_ = ls[0 .. n - 1]
            ls = ls[n ..]

            row.append @inputTemplate letter: p[0], weight: p[1] for p in ls_
            rowsElement.append row

        # add a new input.
        if n is 4
            row = $(@rowTemplate({}).trim())
            rowsElement.append row

        inp = $(@inputTemplate({letter: "", weight: ""}).trim())
        inp.find(".letter").prop 'disabled', false
        row.append inp
        (inp.find(".letter").get())[0].focus()


    renderError: (model, error) ->
        @$el.append @errorTemplate error: error unless @$el.find(".error").length
