TaskModel = Backbone.Model.extend
    defaults:
        completed: false
        letters: []
        weights: []
        exams: null

    initialize: () ->
        # Be sure our letter array has one, and only one space, at its last position.
        ls = @get "letters"
        ls.push ' '
        _.uniq ls
        unless ls[ls.length - 1] is ' '
            ls = _.filter(ls, (e) -> e isnt ' ')
            ls.push(' ' )
        @set 'letters', ls

        # calculate weights for each letter
        @set "weights", @simpleWeights()

        # init the examcollection
        @set "exams", new ExamCollection()


    # Calculate propability for each letter appearing in an exams string
    # For ' ' we have probability as given, all other letters have equal probability
    #
    # @param space probability for the ' ' letter
    # @return array
    simpleWeights: (space=0.1) ->
        space = 0 if space >= 1 or space <= 0
        ls = @get("letters")
        p = (1 - space) / (ls.length - 1)

        ws = _.map ls, ((e) -> if e is ' ' then space else p)
        ws[ws.length - 1] = 1 - _.reduce ws[0 ... -1], ((m, v) -> m + v)
        return ws
    
        
    # Add an exam to the exam collection after the exam is marked complete
    #
    # @param exam The completed exam
    # @return void
    completeExam: (exam) ->
        exam.collection = @get "exams"
        exam.save()
        @get("exams").add exam
