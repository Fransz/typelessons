App = App or {}

App.TaskModel = Backbone.Model.extend
    localStorage: new Backbone.LocalStorage "typelessons.tasks"

    defaults:
        completed: false
        letters: []
        weights: []
        exams: []


    # Initialize a new model
    # Some attributes might have to be initialized if this models object was not retrieved from storage.
    #
    # @return void
    initialize: () ->
        # Be sure our letter array has one, and only one space, at its last position.
        ls = @get "letters"
        ls = ls.sort()
        ls.push ' '
        ls = _.uniq ls
        unless ls[ls.length - 1] is ' '
            ls = _.filter(ls, (e) -> e isnt ' ')
            ls.push(' ' )
        @set 'letters', ls

        if @get("weights").length
            # weights are given, be sure given they count up to 1 by manipulating the last (space) weight.
            ws = @get "weights"
            ws[ws.length - 1] = 1 - _.reduce ws[0 ... -1], ((m, v) -> m + v), 0
        else
            # weights are not given, calculate weights for each letter.
            @set "weights", @simpleWeights()

        # init the examcollection
        @set "exams", new App.ExamCollection(@get "exams")



    # Validates a taskmodel
    #
    # @param attrs the attributes of this model.
    # @param options passes to set, save.
    # @return error string if the model doesnt validate; "" if we do validate.
    validate: (attrs, opts) ->
        error = ""
        ls = attrs.letters
        ws = attrs.weights

        if ls[ls.length - 1] isnt ' '
            error = 'A tasks letters should have a space in its last position'

        if ws[ws.length - 1] isnt 1 - _.reduce ws[0 ... -1], ((m, v) -> m + v), 0
            error = 'A tasks weights (without space) should sum up to 1 - spaces weight'

        return error

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
        ws[ws.length - 1] = 1 - _.reduce ws[0 ... -1], ((m, v) -> m + v), 0
        return ws
    
        
    # Add an exam to the exam collection after the exam is marked complete
    #
    # @param exam The completed exam
    # @return void
    completeExam: (exam) ->
        @get("exams").add exam
        @save()

    # Creates a string from all letters in the task
    #
    # @return string
    letterString: () ->
        return _.clone(@get("letters")).sort().join('')
