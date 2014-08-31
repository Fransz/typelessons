App = App or {}

App.NewTaskView = Backbone.View.extend
    el: "#newtask"

    rowTemplate: _.template @$("#newmodelrowtemplate").html()
    inputTemplate: _.template @$("#newmodelinputtemplate").html()
    errorTemplate: _.template @$("#newmodelerrortemplate").html()
    spaceHtml: @$ "#newmodelspacetemplate"

    events:
        "keypress .letter" : "addLetters"
        "valueofaweight" : "resetWeights"

    # flag signs that some weight was filled in by the user.
    weightChanged: false
    

    initialize: () ->
        @listenTo @model, "change:letters", @render
        @listenTo @model, "invalid", @renderError
        # @model.set "letters", { "a": 1}
        # @model.set "letters", { "e": 1, "f": 2, "g": 3, "h": 4,  "a": 1, "b": 2, "c": 3, "d": 4}
        @render()


    # Add the given letter to our model.
    #
    # @param evt The event
    # #return void
    addLetters: (evt) ->
        elm = $(evt.target)
        letter = String.fromCharCode evt.which
        console.log letter

        if elm.val()
            return

        @model.addLetter(letter)

        # get the pressed key;
        # if the input already has content, and the key is not bs
        #   call @model.addLetter
        #     if false
        #       Error: This letter is in the task already
        #
        #     if true
        #        if customWeightFlag
        #           focus weight field.
        #        call @model.setWeights unless customWeightFlag is set
        # else Error: Only one letter at a time.




    # Set the custom weight flag, reset the NewModel.
    #
    # @param evt The event
    # #return void
    resetWeights: () ->

        # get the new weight
        # get the letter
        # set the weight for the letter
        # set the customWeightFlag

    cancel: () ->
        # clear all letters and weights

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
    #
    # @return void
    render: () ->
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
        if n is 4 then row = $(@rowTemplate({}).trim())
        row.append @inputTemplate letter: "", weight: ""
        if n is 4 then rowsElement.append row


    renderError: (model, error) ->
        @$el.append @errorTemplate error: error 
