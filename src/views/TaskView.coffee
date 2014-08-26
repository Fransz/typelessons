TaskView = Backbone.View.extend
    events:
        dblclick: @createExam

    initialize: () ->

    createExam: () ->
        examModel = new ExamModel letters: @model.get "letters"
        examView = new ExamView  model: examModel, task: @.model

    # Add the exam to the models exam collection after the exam is marked complete
    #
    # @return void
    completeExam: (exam) ->
        examView = null
        @model.get("exams").add exam
