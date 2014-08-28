TaskCollectionView = Backbone.View.extend
    el: "#tasks"

    initialize: () ->
        @tasks = new TaskCollection()
        @listenTo @tasks, "add", @render

        # initialisation
        t = new TaskModel letters: ['g', 'h']
        tt = new TaskModel letters: ['y', 't']
        ttt = new TaskModel letters: ['b', 'n']
        @tasks.add [t, tt, ttt]

    render: (task) ->
        taskView = new TaskView
            model: task
        @$el.append taskView.render().el
