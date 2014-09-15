App = App or {}

App.TaskView = Backbone.View.extend
    tagName: "div"
    className: "task"

    template: _.template @$("#tasktemplate").html()
    
    events:
        click: "showTaskDetail"

    # Initialize the taskview
    #
    # @return void
    initialize: () ->
        @listenTo @model, "sync", @render

    # Shows a tasks detail
    # Event handler for the DOM click event on this taskview
    # We just fire an onther event listened to by the Application view.
    #
    # @return void
    showTaskDetail: () ->
        @trigger "showDetail", @model

    # Render the task. We show the models letters but not spaces, and stats for completed exams.
    #
    # @return void
    render: () ->
        letters = _.filter(@model.get("letters"), (l) -> l isnt ' ')
        score = @model.get("exams").sumScore()

        s = score.time % 60
        m = Math.floor(score.time / 60)
        score.time = "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"

        @$el.html @template letters: letters, score: score
        return @
