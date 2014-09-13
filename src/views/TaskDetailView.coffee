App = App or {}

App.TaskDetailView = Backbone.View.extend
    lettertemplate: _.template @$("#taskdetaillettertemplate").html()
    
    el: "#taskdetail"

    initialize: () ->
        @$el.show()
        @render()

    render: () ->
        letters = _.filter(@model.get("letters"), (l) -> l isnt ' ')
        # score = @model.get("exams").cummScore()

        # s = score.time % 60
        # m = Math.floor(score.time / 60)
        # score.time = "#{if(m < 10) then '0' + m else m}:#{if(s < 10) then '0' + s else s}"

        @$(".letters").html @lettertemplate letters: letters
        return @
