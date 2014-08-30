App = App or {}

App.NewTaskView = Backbone.View.extend
    el: "#newtask"

    rowTemplate: _.template @$("#newmodelrowtemplate").html()
    inputTemplate: _.template @$("#newmodelinputtemplate").html()
    spaceHtml: @$ "#newmodelspacetemplate"

    events:
        "valueofaletter" : @resetLetters
        "valueofaweight" : @resetWeights

    # flag signs that some weight was filled in by the user.
    weightChanged: false
    

    initialize: () ->
        @listenTo @model, "change:letters", @render
        # @model.set "letters", { "a": 1}
        # @model.set "letters", { "e": 1, "f": 2, "g": 3, "h": 4,  "a": 1, "b": 2, "c": 3, "d": 4}
        @render()


    # Collect all letters and weights on the form, reset our new model.
    #
    # @param evt The event
    # #return void
    # @resetLetters: () ->

    # Set the custom weight flag, reset the NewModel.
    #
    # @param evt The event
    # #return void
    # @resetWeights: () ->

    # render all letter and weight pairs of the NewModel, 4 in a row.
    #
    # @return void
    render: () ->
        console.log "rendering"
        n = 4                                       # nr inputs on a row.
        ls = _.pairs(@model.get "letters")                # letter weight tuppels

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
