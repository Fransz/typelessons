ExamModel = Backbone.Model.extend
    defaults:
        letters: []
        weights: []

        testString: ""
        typedString: ""

        lastChar: ''
        lastScore: ""
        completed: false

        time: 0
        scores: {}

    # Initialize a new model
    # Some attributes might have to be initialized if this models object was not retrieved from storage.
    #
    # @return void
    initialize: () ->
        # initialize the scores, only if no scores where given.
        if _.isEmpty @get("scores")
            s = {}
            ls = @get "letters"
            _.each ls, (e) -> s[e] = {pass: 0, fail: 0}
            @set "scores", s

        @set "testString", @mkString() unless (@get "testString").length


    # Generate a random string consisting only of our letters.
    #
    # @param l The length of the string.
    # @return The generated string
    mkString: (l=10) ->
        ls = @get "letters"
        ws = @get "weights"
        ns = _.filter ls, ((c) -> c isnt ' ')                       # letters without ' ' letter

        cs = App.sample ls, ws , l                                  # Array of random letters from our ls.

        # replace leading, and trailing spaces.
        cs[0] = ns[0] if cs[0] is ' '
        cs[cs.length - 1] = ns[ns.length - 1] if cs[cs.length - 1] is ' '

        # replace double spaces.
        cs[i - 1] = ns[i % ns.length] for i in [1 .. cs.length] when cs[i] is ' ' and cs[i - 1] is ' '

        cs.join('')


    # Adds a character to the typed string, recalc stats.
    # 
    # @param c The typed character
    # @return void
    addKeyStroke: (c) ->
        @set "typedString", @get("typedString") + c
        @lastScore()

        if @get("typedString").length >= @get("testString").length
            @set "completed", true
            return

        # be sure event changed:lastChar is triggered
        @set "lastChar", '', silent: true
        @set "lastChar", c


    # Calculate the stats for the last character in the typed string.
    # The stats are added with the character tested, not with the character entered.
    #
    # @return void
    lastScore: () ->
        p = @get("typedString").length - 1
        typed = @get("typedString")[p]
        test = @get("testString")[p]
        score = if typed is test then "pass" else "fail"

        # Add the score to the scores, and set last score.
        scores = @get "scores"
        scores[test][score]++
        @set "scores", scores
        @set "lastScore", score


    # Calculate the sum off all pass and fail scores.
    #
    # @return Object
    sumScore: () ->
        scores = @get "scores"
        f = (m, v, i, l) -> m + v

        {
            pass: _.reduce(_.pluck(scores, "pass"), f, 0),
            fail: _.reduce(_.pluck(scores, "fail"), f, 0)
        }
