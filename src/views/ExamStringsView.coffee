ExamStringsView = Backbone.View.extend
    typedStringTemplate: _.template '<%= shortenedString %><span class="<%= lastScore %>"><%= lastChar %></span>'

    initialize: () ->
        @listenTo @model, "change:testString", @renderTestString
        @listenTo @model, "change:lastChar", @renderTypedString

        @model.trigger "change:testString"


    renderTestString: () ->
        @$("#teststring").html @model.get "testString"

    renderTypedString: () ->
        typedString = @model.get "typedString"
        shortenedString = typedString.slice 0, typedString.length - 1
        lastChar = @model.get "lastChar"
        lastScore = @model.get "lastScore"

        @$("#typedString").html @typedStringTemplate { shortenedString: shortenedString, lastChar: lastChar, lastScore: lastScore }
