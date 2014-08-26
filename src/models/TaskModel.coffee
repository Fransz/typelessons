TaskModel = Backbone.Model.extend
    defaults:
        completed: false
        letters: []
        weights: []
        exams: new ExamCollection()

    initialize: () ->
        # Be sure our letter array has one, and only one space.
        ls = @get "letters"
        ls.push ' '
        _.uniq ls
        @set 'letters', ls

        # calculate weights for each letter
        @set "weights", @calcSimpleWeights()


    # Calculate propability for each letter appearing in an exams string
    # For ' ' we have probability as given, all other letters have equal probability
    #
    # @param space probability for the ' ' letter
    # @return array
    calcSimpleWeights: (space=0.1) ->
        space = 0 if space >= 1 or space <= 0
        ls = @get("letters")
        p = (1 - space) / (ls.length - 1)

        f = (e, i, l) -> if e is ' ' then space else p
        _.map ls, f
    
        
    # Add an exam to the exam collection after the exam is marked complete
    #
    # @param exam The completed exam
    # @return void
    completeExam: (exam) ->
        @get("exams").add exam
