TaskView = Backbone.View.extend
    events:
        dblclick: @createExam

    initialize: () ->

    createExam: () ->
        examModel = new ExamModel({ letters: @model.get "letters" })
        examView = new ExamView({ model: examModel})

    completeExam: (exam) ->
        examView = null
        console.log "completed"
