App = App or {}

App.NewTaskModel = Backbone.Model.extend
    defaults:
        tasks: []                                                                   # Collection with all known tasks
        letters:
            space: 0.1                                                              # We always have a space with weight 0.1

    # Validation for submitting a newTask. 
    # Validation for new letters and weights is done while adding the letter or weight.
    #
    # @param attrs the attributes of this model.
    # @param options passes to set, save.
    # @return error string if the model doesnt validate; "" if we do validate.
    validate: (attrs, opts) ->
        error = ""
        ls = attrs.letters
        ls_ = _.clone attrs.letters

        delete ls_["space"]
        s = _.size(ls_)                                                           # size without space

        # validate letters cnt; space existence.
        if s is 0 or s %% 2 is 1 or s > 8 or not "space" of ls
            error = "A task should have 2, 4, 6 or 8 letters and one space!"

        # validate weights;
        if Math.abs(_.reduce(ls, ((m, v) -> m + v), 0) - 1) > 0.00001
            error = "Weigths do not add up to 1!"

        # validate existing
        ls_[' '] = 0
        s = _.keys(ls_).sort().join('')
        if @get("tasks").some(((t) -> t.letterString() is s))
            error = "Task already exists!"
        return error

        
    # Add a letter to the array of letters.
    # We have to validate here if the letter is in the task already.
    #
    # @param letter the letter to add
    # @return boolean true if the letter was added.
    addLetter: (l) ->
        ls = _.clone(@get "letters")

        error = ""
        if !error and l of ls
            error = "The letter is already in the task"

        if !error and l is " "
            error = "The space should always be in a task; its weight cannot be changed"

        if !error and l.trim() is ""
            error = "No valid letter"

        if error
            this.trigger('invalid', this, error, {validationError: error})
            return false

        ls[l] = 0
        @set "letters", ls
        return true


    # Delete a letter from the array of letters.
    #
    # @param letter the letter to delete
    # @return void
    deleteLetter: (letter) ->
        if letter is ""
            error = "No letter to delete"
            this.trigger('invalid', this, error, {validationError: error})
            return false

        ls = @get "letters"
        delete ls[letter]

    # Add a weight for a letter
    # We also validate the weight here.
    #
    # @param letter the letter to add the weight for.
    # @param weight the weight for the letter
    # @return boolean true if the weight could be set.
    addWeight: (letter, weight) ->
        ls = _.clone(@get "letters")
        w = parseFloat weight.replace /,/g, "."

        error = ""
        if _.isNaN w
            error = "Weights must be less then one"

        if w > 1
            error = "Weights must be less then one"

        if not letter
            error = "No letter for this weight"

        if error
            this.trigger('invalid', this, error, {validationError: error})
            return false

        # Validate if weights add up to one. Even if we don validate this test, still set with the given weigths.
        # It cannot be submitted, and the user will have the intention to fix it.
        delete ls[letter]
        if Math.abs(_.reduce(ls, ((m, v) -> m + v), 0) + w - 1) > 0.00001
            error = "Weigths do not add up to 1"
            
            ls[letter] = w
            @set "letters", ls

            this.trigger('invalid', this, error, {validationError: error})
            return false

        ls[letter] = w
        @set "letters", ls
        return true

    # get a weight for a letter
    #
    # @param letter the letter to get the weight for.
    # @return float the letters weight
    getWeight: (letter, weight) ->
        ls = @get "letters"
        ls[letter]

    # calculate even weights for each letter.
    # A letter "space" should exist.
    #
    # @return void
    evenWeights: () ->
        ls = @get "letters"
        space = ls["space"]
        delete ls["space"]

        p = (1 - space) / _.keys(ls).length
        _.each(ls, (v, k) -> ls[k] = p)
        ls["space"] = space

        @set "letters", ls
