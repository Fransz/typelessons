App = App or {}

App.TaskCollection = Backbone.Collection.extend
    model: App.TaskModel
    localStorage: new Backbone.LocalStorage "typelessons.tasks"
