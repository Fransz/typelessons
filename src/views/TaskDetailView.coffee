App = App or {}

App.TaskDetailView = Backbone.View.extend
    lettertemplate: _.template @$("#taskdetaillettertemplate").html()
    weighttemplate: _.template @$("#taskdetailweighttemplate").html()
    triestemplate: _.template @$("#taskdetailtriestemplate").html()
    scoretemplate: _.template @$("#taskdetailscoretemplate").html()
    
    el: "#taskdetail"

    events:
        "click #taskdetailcancelbutton": "cancel"

    initialize: () ->
        @$el.show()
        @render()

    # Cancels the detail view.
    #
    # @return void
    cancel: () ->
        @$el.hide()

    # displays the details of a task
    # Weights are displayed in 3 decimals without the leading zero.
    #
    # @return void
    render: () ->
        # score = @model.get("exams").cummScore()

        # s = score.time % 60
        # m = Math.floor(score.time / 60)
        # score.time = "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"

        letters = @model.get "letters"
        @$(".letters").html @lettertemplate letters: letters

        weights = _.clone(@model.get "weights")
        weights = weights.map(((w) -> w.toFixed(3)[1 ..]))
        @$(".weights").html @weighttemplate weights: weights

        cummScore = @model.get("exams").cummScore()
        s = cummScore.time % 60
        m = Math.floor(cummScore.time / 60)
        cummScore.time = "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"
        @$(".tries").html @triestemplate tries: cummScore.tries

        @$(".avgscore .scorewrapper").html @scoretemplate score: cummScore
        @$(".sumscore .scorewrapper").html @scoretemplate score: cummScore
        @$(".lastscore .scorewrapper").html @scoretemplate score: cummScore
