App = App or {}

App.NewTaskView = Backbone.View.extend
    el: "#newtask"

    rowTemplate: _.template @$("#rowtemplate").html()

    events: {}

    initialize: () ->
        @renderEmptyRow()

    render: (letters) ->
        rowsElement = @$ "#rows"
        rowsElement.append @rowTemplate letter: p[0], weight: p[1]  for p in _.pairs(letters)

        @renderEmptyRow()

    renderEmptyRow: () ->
        rowsElement = @$ "#rows"
        rowsElement.append @rowTemplate letter: "", weight: ""
