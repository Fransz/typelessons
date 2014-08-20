ExamModel = Backbone.Model.extend({
    defaults:
        letters: []

        testString: ""
        typedString: ""
        position: 0

        duration: 0
        scores: {}


    initialize: () ->
        # Be sure our letter array has one, and only one space.
        ls = @get 'letters'
        ls.push ' '
        _.uniq ls
        @set 'letters', ls

        # initialize the scores
        s = {}
        _.each ls, (e) -> s[e] = {pass: 0, fail: 0}
        @set 'scores', s

        @set 'testString', @mkString()

    # Generate a random string consisting only of our letters.
    #
    # @param l The length of the string.
    # @return The generated string
    mkString: (l=100) ->
        ls = @get 'letters'
        cs = (ls[Math.floor Math.random() * ls.length] for n in [0 ... l])

        f = (m, v, i, l) -> m + v
        _.reduce cs, f, ""


    # Adds a character to the typed string, recalc stats.
    # 
    # @param c The typed character
    # @return void
    addKeyStroke: (c) ->
        @set "typedString", @get("typedString") + c
        @calcScores()
        @set "position", @get("position") + 1


    # Calculate the stats for the character at the current position in the teststring.
    # The stats are added with the character teseted, not with the character entered.
    #
    # @return void
    calcScores: () ->
        p = @get "position"
        typed = @get("typedString")[p]
        test = @get("testString")[p]
        score = if typed is test then "pass" else "fail"
        @get("scores")[test][score]++
})
