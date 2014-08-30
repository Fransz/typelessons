App = App or {}

App.NewTaskModel = Backbone.Model.extend
    defaults:
        letters: {}

    # Add a letter to the array of letters.
    #
    # @param letter the letter to add
    # @return boolean true if the letter was added.
    addLetter: (l) ->
        ls = @get "letters"
        ls[l] = 0 unless l of ls
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
