ExamModel = Backbone.Model.extend({
    defaults:
        letters: []
        duration: 0
        scores: {}

    initialize: ->
        # Be sure our letter array has one, and only one space.
        ls = @get 'letters'
        ls.push ' '
        _.uniq ls
        @set 'letters', ls

        # initialize the scores
        s = {}
        _.each ls, (e) -> s[e] = {pass: 0, fail: 0}
        @set 'scores', s

    # Generate a random string consisting only of our letters.
    #
    # @param l The length of the string.
    # @return The generated string
    mkString: (l=30) ->
        ls = @get 'letters'
        cs = (ls[Math.floor Math.random() * ls.length] for n in [0 ... l])

        f = (m, v, i, l) -> m + v
        _.reduce(cs, f, "")
})
