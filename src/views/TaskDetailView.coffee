App = App or {}

App.TaskDetailView = Backbone.View.extend
    lettertemplate: _.template @$("#taskdetaillettertemplate").html()
    weighttemplate: _.template @$("#taskdetailweighttemplate").html()
    triestemplate: _.template @$("#taskdetailtriestemplate").html()
    scoretemplate: _.template @$("#taskdetailscoretemplate").html()
    
    el: "#taskdetail"

    events:
        "click #taskdetailcancelbutton": "cancel"
        "click #taskdetailtrybutton": "try"

    # Initialize the view.
    #
    # @param  model  the taskModel for which this view is created
    # @return void
    initialize: () ->
        @$el.show()
        @render()

    # Strats an exam for this detailViews task. 
    # The Application view takes care of that.
    #
    # @return void
    try: () ->
        @trigger "newExam", @model
        @$("#taskdetailtrybutton").blur()

    # Cancels the detail view. 
    # The Application view takes care of that.
    #
    # @return void
    cancel: () ->
        @trigger "hideDetail"

    # Hides the current detail view.
    #
    # @return void
    hideDetail: () ->
        @$el.hide()

    # Stops the current task detai.
    # Clean up and unlisten.
    #
    # return void
    stopDetail: () ->
        @undelegateEvents()


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
