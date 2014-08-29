TaskCollectionView = Backbone.View.extend
    el: "#tasks"

    initialize: () ->
        @tasks = new TaskCollection()

        @listenTo @tasks, "add", @render
        @tasks.fetch()

        @_initializeTasks() unless @tasks.length > 0

    # Add all predefined task to the collection, and save them in storage.
    # This should only be done if no tasks are found in storage.
    #
    # @return void
    _initializeTasks: () ->
        # @tasks.create letters: ['x', 'y']
        _.each App.initialModels, (l) => @tasks.create letters: l

    render: (task) ->
        taskView = new TaskView
            model: task
        @$el.append taskView.render().el
