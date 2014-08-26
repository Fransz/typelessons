describe("An Task view", function () {

    describe("when newly created", function() {
        var taskModel, taskView;
        beforeEach(function () {
            examModel = new ExamModel({letters: ['g', 'h', ' ']});
            taskModel = new TaskModel({letters: ['g', 'h']});
            taskView = new TaskView({model: taskModel});
        });

    });
});
