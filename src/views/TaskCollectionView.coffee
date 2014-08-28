TaskCollectionView = Backbone.View.extend
    el: "#tasks"

    initialize: () ->
        @tasks = new TaskCollection()
        @listenTo @tasks, "add", @render

        # initialisation
        f = (l) -> new TaskModel letters: l.split('')
        @tasks.add _.map App.initialModels, f

    render: (task) ->
        taskView = new TaskView
            model: task
        @$el.append taskView.render().el
