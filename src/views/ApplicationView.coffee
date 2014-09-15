App = App or {}

App.ApplicationView = Backbone.View.extend
    # A collection with all task models.
    tasks: null

    # An array with views for all entered tasks
    taskViews: []

    # A view for defining new tasks.
    newTaskView: null

    # A view for an exam.
    currentExamView: null

    el: "body"

    events: {
        "click #appcontrols #newtaskcontrol": "showNewTaskForm"
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
    # For the task a view is made, we this these views, and listen to it.
    #
    # @param task the task to be rendered
    # @return void
    renderTask: (task) ->
        taskView = new App.TaskView
            model: task
        @listenTo taskView, "newExam", @showExam

        @taskViews.push taskView

        grp = task.get("letters").length - 1
        el = @$ "#tasks ##{grp}lettertasks"

        el.append taskView.render().el

        # nr of tasks
        hdr = el.closest(".taskgroupwrapper").find(".taskgroupheader .count")
        nr = el.children().length
        hdr.html "#{nr} tasks"


    # Enable the new task section.
    # Dom Eventhandler for the newtask button.
    #
    # @return void
    showNewTaskForm: () ->
        @hideNewTaskForm()
        @$("#newtask").show()

        @newTaskView = new App.NewTaskView model: new App.NewTaskModel()
        @listenTo @newTaskView, "cancelNewTask", @hideNewTaskForm
        @listenTo @newTaskView, "submitNewTask", @submitNewTask

    # Disable the new task section, clean up.
    # Eventhandler for the newTaskView's submitNewTask event.
    #
    # @return void
    hideNewTaskForm: () ->
        if @newTaskView
            @newTaskView.undelegateEvents()
            @stopListening @newTaskView

        @$("#newtask").hide()
        @newTaskView = null

    # Add a new task, disable tasksection.
    # Eventhandler for the newTaskView's cancelNewTask event.
    #
    # @return void
    submitNewTask: (letters) ->
        @hideNewTaskForm()
        ls = _.keys letters
        ws = _.map(ls, ((l) -> letters[l]))
        @tasks.create letters: ls, weights: ws

    # Open a new exam view.
    # Eventhandler for all taskView's newExam event.
    #
    # @return void
    showExam: (taskModel) ->
        @hideExam()
        examModel = new App.ExamModel
                        letters: taskModel.get "letters"
                        weights: taskModel.get "weights"
        examView = new App.ExamView
                        model: examModel
                        task: taskModel

        @currentExamView = examView
        @listenTo examView, "hideExam", @hideExam

    # Hides a finished, or unfinished exam.
    # Event handler for the current examView's finishExam event.
    #
    # return void
    hideExam: () ->
        if @currentExamView
            @currentExamView.stopExam()
            @currentExamView.hideExam()

        @currentExamView = null
