App = App or {}

App.ExamCollection = Backbone.Collection.extend
    model: App.ExamModel

    # Calculate the sum scores for all exams.
    #
    # @return object { pass: fail: time: tries }
    sumScore: () ->
        ss = _.map @models, (m) -> m.sumScore()                             # Array with total scores for each exam
        ts = _.map @models, (m) -> m.get "time"                             # Array with times for each exam

        score =
            pass: _.reduce(_.pluck(ss, "pass"), ((m, s) -> m + s), 0)
            fail: _.reduce(_.pluck(ss, "fail"), ((m, s) -> m + s), 0)
            time: _.reduce(ts, ((m, s) -> m + s), 0)
            tries: ss.length

    # calculate the average score for all exams.
    #
    # @return object { pass: fail: time: tries: }
    avgScore: () ->
        sumScore = @sumScore()
        tries = if sumScore.tries then sumScore.tries else 1

        score =
            pass: sumScore.pass / tries
            fail: sumScore.fail / tries
            time: sumScore.time / tries

    # calculate the last exam score.
    #
    # @return object { pass: fail: time: tries: }
    lastScore: () ->
        exam = @at @length - 1
        if exam?
            score = exam.sumScore()
            score.time = exam.get "time"
        else
            score = { pass: 0, fail:0 , time: 0 } 
        return score

