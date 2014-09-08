App = App or {}

App.TaskView = Backbone.View.extend
    tagName: "div"
    className: "task"

    template: _.template @$("#tasktemplate").html()
    
    events:
        dblclick: "createExam"


    initialize: () ->
        @listenTo @model, "sync", @render

    createExam: () ->
        examModel = new App.ExamModel
                        letters: @model.get "letters"
                        weights: @model.get "weights"
        examView = new App.ExamView
                        model: examModel
                        task: @model


    # Render the task. We show the models letters but not spaces, and stats for completed exams.
    #
    # @return void
    render: () ->
        letters = _.filter(@model.get("letters"), (l) -> l isnt ' ')
        score = @model.get("exams").cummScore()
        @$el.html @template letters: letters, score: score
        return @
