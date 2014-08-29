App = App or {}

App.TaskCollectionView = Backbone.View.extend
    # A collection with al task models.
    tasks: null

    # An array with a view for all endered tasks
    taskViews: []

    el: "#tasks"

    initialize: () ->
        @tasks = new App.TaskCollection()

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
        # create a taskView for the tobe rendered task, keep it.
        taskView = new App.TaskView
            model: task
        @taskViews.push taskView

        @$el.append taskView.render().el
