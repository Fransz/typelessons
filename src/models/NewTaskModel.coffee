App = App or {}

App.NewTaskModel = Backbone.Model.extend
    defaults:
        letters: {}

    # Add a letter to the array of letters.
    #
    # @param letter the letter to add
    # @return boolean true if the letter was added.
    addLetter: () ->

    # Add a weight for a letter
    #
    # @param letter the letter to add the weight for.
    # @param weight the weight for the letter
    # @return void
    addWeight: (letter, weight) ->

    # calculate even weights for each letter
    #
    # @return void
    autoWeights: () ->
