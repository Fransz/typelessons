ExamCollection = Backbone.Collection.extend
    model: ExamModel

    # Calculate the cumm stats for all exams.
    #
    # @return object { pass: fail: time: tries }
    cummStats: () ->
        ss = _.map @models, (m) -> m.calcSumStats()                             # Array with sumStats for each exam

        stats =
            pass: _.reduce(_.pluck(ss, "pass"), ((m, s) -> m + s), 0)
            fail: _.reduce(_.pluck(ss, "fail"), ((m, s) -> m + s), 0)
            time: 0
            tries: ss.length

