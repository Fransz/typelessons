ExamCollection = Backbone.Collection.extend
    model: ExamModel

    # Calculate the cumm scores for all exams.
    #
    # @return object { pass: fail: time: tries }
    cummScore: () ->
        ss = _.map @models, (m) -> m.sumScore()                             # Array with total scores for each exam
        ts = _.map @models, (m) -> m.get "time"                             # Array with times for each exam

        score =
            pass: _.reduce(_.pluck(ss, "pass"), ((m, s) -> m + s), 0)
            fail: _.reduce(_.pluck(ss, "fail"), ((m, s) -> m + s), 0)
            time: _.reduce(ts, ((m, s) -> m + s), 0)
            tries: ss.length

