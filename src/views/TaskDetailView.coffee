App = App or {}

App.TaskDetailView = Backbone.View.extend
    lettertemplate: _.template @$("#taskdetaillettertemplate").html()
    
    el: "#taskdetail"

    initialize: () ->
        @$el.show()
        @render()

    # displays the details of a task
    # Weights are displayed in 3 decimals without the leading zero.
    #
    # @return void
    render: () ->
        letters = @model.get "letters"
        weights = _.clone(@model.get "weights")
        weights = weights.map(((w) -> w.toFixed(3)[1 ..]))
        # score = @model.get("exams").cummScore()

        # s = score.time % 60
        # m = Math.floor(score.time / 60)
        # score.time = "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"

        @$(".letters").html @lettertemplate letters: letters, weights: weights
        return @
