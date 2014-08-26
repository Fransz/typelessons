TaskView = Backbone.View.extend
    template: _.template """
        <div class="task">
            <%= letters %>
            <span><%= stats.pass %></span>
            <span><%= stats.fail %></span>
            <span><%= stats.time %></span>
            <span><%= stats.tries %></span>
        </div>
    """
    
    events:
        dblclick: "createExam"

    initialize: () ->

    createExam: () ->
        examModel = new ExamModel letters: @model.get "letters"
        examView = new ExamView  model: examModel, task: @.model


    # Render the task. We show the models letters, and stats for completed exams.
    #
    # @return void
    render: () ->
        letters = @model.get "letters"
        stats = @model.get("exams").cummStats()
        @$el.html @template letters: letters, stats: stats
        return @
