App = App or {}

App.NewTaskModel = Backbone.Model.extend
    defaults:
        letters: {}

    # Validator for this model, checks letters for ascii;
    # Check weights, but only if we create a task from this NewTask
    #
    # @param attrs The models attributes to be validated.
    # @param options options for attribute
    # @return undefined if all is well
    #         an error messages when problems are found
    # validate: (attrs, options) ->
        

    # Add a letter to the array of letters.
    # Adding a letter twice is easily prevented, we let our view know with a validation event.
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

    # Add a weight for a letter
    #
    # @param letter the letter to add the weight for.
    # @param weight the weight for the letter
    # @return void
    addWeight: (letter, weight) ->
        ls = @get "letters"
        ls[letter] = weight
        @set "letters", ls

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
