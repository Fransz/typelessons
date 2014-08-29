TaskView = Backbone.View.extend
    template: _.template """
        <div class="task">
            <%= letters %>
            <span><%= score.pass %></span>
            <span><%= score.fail %></span>
            <span><%= score.time %></span>
            <span><%= score.tries %></span>
        </div>
    """
    
    events:
        dblclick: "createExam"


    initialize: () ->
        @listenTo @model, "sync", @render

    createExam: () ->
        examModel = new ExamModel
                        letters: @model.get "letters"
                        weights: @model.get "weights"
        examView = new ExamView
                        model: examModel
                        task: @.model


    # Render the task. We show the models letters, and stats for completed exams.
    #
    # @return void
    render: () ->
        letters = @model.get "letters"
        score = @model.get("exams").cummScore()
        @$el.html @template letters: letters, score: score
        return @
