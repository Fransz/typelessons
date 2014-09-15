App = App or {}

App.TaskView = Backbone.View.extend
    tagName: "div"
    className: "task"

    template: _.template @$("#tasktemplate").html()
    
    events:
        dblclick: "createExam"
        click: "showTaskDetail"

    initialize: () ->
        @listenTo @model, "sync", @render

    createExam: () ->
        @trigger "newExam", @model

    showTaskDetail: () ->
        @trigger "showDetail", @model

    # Render the task. We show the models letters but not spaces, and stats for completed exams.
    #
    # @return void
    render: () ->
        letters = _.filter(@model.get("letters"), (l) -> l isnt ' ')
        score = @model.get("exams").cummScore()

        s = score.time % 60
        m = Math.floor(score.time / 60)
        score.time = "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"

        @$el.html @template letters: letters, score: score
        return @
