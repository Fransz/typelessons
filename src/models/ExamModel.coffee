ExamModel = Backbone.Model.extend({
    defaults:
        letters: []

        testString: ""
        typedString: ""

        lastChar: ''
        lastScore: ""
        completed: false

        duration: 0
        scores: {}


    initialize: () ->
        # initialize the scores
        s = {}
        ls = @get "letters"
        _.each ls, (e) -> s[e] = {pass: 0, fail: 0}
        @set "scores", s

        @set "testString", @mkString()

    # Generate a random string consisting only of our letters.
    #
    # @param l The length of the string.
    # @return The generated string
    mkString: (l=10) ->
        ls = @get "letters"
        cs = (ls[Math.floor Math.random() * ls.length] for n in [0 ... l])

        f = (m, v, i, l) -> m + v
        _.reduce cs, f, ""


    # Adds a character to the typed string, recalc stats.
    # 
    # @param c The typed character
    # @return void
    addKeyStroke: (c) ->
        @set "typedString", @get("typedString") + c
        @calcLastScore()

        if @get("typedString").length >= @get("testString").length
            @set "completed", true
            return

        # be sure event changed:lastChar is triggered
        @set "lastChar", '', silent: true
        @set "lastChar", c


    # Calculate the stats for the last character in the typed string.
    # The stats are added with the character teseted, not with the character entered.
    #
    # @return void
    calcLastScore: () ->
        p = @get("typedString").length - 1
        typed = @get("typedString")[p]
        test = @get("testString")[p]
        score = if typed is test then "pass" else "fail"

        # Add the score to the scores, and set last score.
        @get("scores")[test][score]++
        @set "lastScore", score


    # Calculate the sum off all pass and fail scores.
    #
    # @return Object
    calcSumScore: () ->
        scores = @get "scores"
        f = (m, v, i, l) -> m + v

        {
            pass: _.reduce(_.pluck(scores, "pass"), f, 0),
            fail: _.reduce(_.pluck(scores, "fail"), f, 0)
        }
})
