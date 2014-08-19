ExamModel = Backbone.Model.extend({
    defaults:
        letters: []
        duration: 0
        scores: {}

    initialize: ->
        # Be sure our letter array has one, and only one space.
        l = @get 'letters'
        l.push ' '
        _.uniq l
        @set 'letters', l

        # initialize the scores
        s = {}
        _.each l, (e, i, _l) -> s[e] = {pass: 0, fail: 0}
        @set 'scores', s
})
