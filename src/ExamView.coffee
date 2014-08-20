ExamView = Backbone.View.extend
    testStringTemplate: _.template "<%= testString %>"

    initialize: () ->
        @model = new ExamModel { letters: ['q', 'x'] }
        @model.on "change:testString", this.render, this
        @model.trigger "change:testString"


    render: () ->
        @$el.html @testStringTemplate { testString: @model.get "testString" }

examView = new ExamView
    el: "#teststring"
