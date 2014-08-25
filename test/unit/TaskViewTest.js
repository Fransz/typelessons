describe("An Task view", function () {

    describe("when newly created", function() {
        var taskModel, taskView;
        beforeEach(function () {
            taskModel = new TaskModel({letters: ['g', 'h']});
            taskView = new TaskView({model: taskModel});
        });


        it.skip("should have an Exam with the same letteers as the model", function () {
            console.log(taskView);
            expect(taskModel.get("letters")).to.be.eql(taskView.examModel.get("letters"));
        });
    });
});
