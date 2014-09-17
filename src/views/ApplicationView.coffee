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

    # A view for a task detail.
    currentDetailView: null

    el: "body"

    events: {
        "click #appcontrols #newtaskcontrol": "showNewTaskForm"
    }

    initialize: () ->
        @hideExam()
        @hideNewTask()
        @hideTaskDetail()

        @tasks = new App.TaskCollection()
        @listenTo @tasks, "add", @renderTask
        @tasks.fetch(validate: true)

        @_initializeTasks() unless @tasks.length > 0


    # Add all predefined task to the collection, and save them in storage.
    # This should only be done if no tasks are found in storage.
    #
    # @return void
    _initializeTasks: () ->
        _.each App.initialModels, (l) => @tasks.create letters: l


    # render a single task
    # For the task a view is made, we keep these views, and listen to it.
    # eventhandler for tasks:add
    #
    # @param task the task to be rendered
    # @return void
    renderTask: (task) ->
        taskView = new App.TaskView
            model: task
        @listenTo taskView, "newExam", @showExam
        @listenTo taskView, "showDetail", @showTaskDetail

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
        @hideNewTask()
        @hideExam()
        @hideTaskDetail()

        @newTaskView = new App.NewTaskView model: new App.NewTaskModel({tasks: @tasks})
        @listenTo @newTaskView, "cancelNewTask", @hideNewTask
        @listenTo @newTaskView, "hideNewTask", @hideNewTask

    # Disable the new task section, clean up.
    # Eventhandler for the newTaskView's submitNewTask event.
    #
    # @return void
    hideNewTask: () ->
        if @newTaskView
            @newTaskView.stop()
            @newTaskView.hide()
            @stopListening @newTaskView

        @newTaskView = null



    # Open a new exam view.
    # Eventhandler for all taskView's newExam event.
    #
    # @return void
    showExam: (taskModel) ->
        @hideExam()
        @hideNewTask()

        examModel = new App.ExamModel
                        letters: taskModel.get "letters"
                        weights: taskModel.get "weights"
        examView = new App.ExamView
                        model: examModel
                        task: taskModel

        @currentExamView = examView
        @listenTo examView, "hideExam", @hideExam

    # Hides a finished, or unfinished exam.
    # Event handler for the current examView's hideExam event.
    #
    # return void
    hideExam: () ->
        if @currentExamView
            @currentExamView.stopExam()
            @currentExamView.hideExam()
            @stopListening(@currentExamView)

        @currentExamView = null



    # Opens a new detail view.
    # EventHandler for all taskViews showDetail events.
    #
    # return @void
    showTaskDetail: (taskModel) ->
        @hideTaskDetail()
        @hideNewTask()
        @hideExam()

        detailView = new App.TaskDetailView model: taskModel
        @currentDetailView = detailView
        @listenTo detailView, "hideDetail", @hideTaskDetail
        @listenTo detailView, "newExam", @showExam

    # Hide a tasks detail
    # Eventhandler for the current detailViews's hideDetail event.
    #
    # return void
    hideTaskDetail: () ->
        if @currentDetailView
            @currentDetailView.stopDetail()
            @currentDetailView.hideDetail()
            @stopListening(@currentDetailView)

        @currentDetailView = null
