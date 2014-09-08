App = App or {}

App.ApplicationView = Backbone.View.extend
    # A collection with all task models.
    tasks: null

    # An array with views for all entered tasks
    taskViews: []

    # A view for new tasks.
    newTaskView: null

    el: "body"

    events: {
        "click #appcontrols #newtask": "showNewTaskForm"
    }

    initialize: () ->
        @$("#newtask").hide()

        @tasks = new App.TaskCollection()

        @listenTo @tasks, "add", @renderTask
        @tasks.fetch()

        @_initializeTasks() unless @tasks.length > 0


    # Add all predefined task to the collection, and save them in storage.
    # This should only be done if no tasks are found in storage.
    #
    # @return void
    _initializeTasks: () ->
        _.each App.initialModels, (l) => @tasks.create letters: l


    # render a single task
    # For the task a view is made, we keep these views.
    #
    # @param task the task to be rendered
    # @return void
    renderTask: (task) ->
        taskView = new App.TaskView
            model: task
        @taskViews.push taskView

        grp = task.get("letters").length - 1
        el = @$ "#tasks ##{grp}lettertasks"
        el = @$ "#tasks" unless el.length

        el.append taskView.render().el


    # enable the new task section
    #
    # @return void
    showNewTaskForm: () ->
        @$("#newtask").show()
        if @newTaskView
            @stopListening @newTaskView

        @newTaskView = new App.NewTaskView model: new App.NewTaskModel()
        @listenTo @newTaskView, "cancelNewTask", @hideNewTaskForm
        @listenTo @newTaskView, "submitNewTask", @submitNewTask

    hideNewTaskForm: () ->
        @stopListening @newTaskView
        @$("#newtask").hide()

    submitNewTask: (letters) ->
        @stopListening @newTaskView
        @$("#newtask").hide()

        ls = _.keys letters
        ws = _.map(ls, ((l) -> letters[l]))
        @tasks.create letters: ls, weights: ws

