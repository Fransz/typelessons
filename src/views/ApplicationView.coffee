App = App or {}

App.ApplicationView = Backbone.View.extend
    # A collection with all task models.
    tasks: null

    # An array with views for all endered tasks
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
        _.each App.initialModels, (l) => @tasks.create letters: l

    render: (task) ->
        # create a taskView for the tobe rendered task, keep it.
        taskView = new App.TaskView
            model: task
        @taskViews.push taskView

        grp = task.get("letters").length - 1
        el = @$ "##{grp}letters"
        el = @$el unless el.length

        el.append taskView.render().el
