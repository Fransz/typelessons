App = App or {}

App.NewTaskModel = Backbone.Model.extend
    defaults:
        letters: {}

    # Add a letter to the array of letters.
    # We have to validate here if the letter is in the task already.
    #
    # @param letter the letter to add
    # @return boolean true if the letter was added.
    addLetter: (l) ->
        ls = _.clone(@get "letters")
        if l of ls
            error = "The letter is already in the task"
            this.trigger('invalid', this, error, {validationError: error})
            return false

        ls[l] = 0
        @set "letters", ls
        return true

    # Add a weight for a letter
    #
    # @param letter the letter to add the weight for.
    # @param weight the weight for the letter
    # @return boolean true if the weight could be set.
    addWeight: (letter, weight) ->
        ls = _.clone(@get "letters")

        w = Number.parseFloat weight.replace /,/g, "."

        if _.isNaN w
            error = "Weights must be less then one"
            this.trigger('invalid', this, error, {validationError: error})
            return false

        if w > 1
            error = "Weights must be less then one"
            this.trigger('invalid', this, error, {validationError: error})
            return false

        if not letter
            error = "No letter for this weight"
            this.trigger('invalid', this, error, {validationError: error})
            return false

        if _.reduce(@get("letters"), ((m, v) -> m + v), 0) + w > 1
            error = "Weigths do not add up to 1"
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

    # calculate even weights for each letter
    #
    # @return void
    autoWeights: () ->
        # probability for the space character added in a real model.
        space = 0.1

        ls = @get "letters"
        p = (1 - space) / _.keys(ls).length
        _.each(ls, (v, k) -> ls[k] = p)
        @set "letters", ls
