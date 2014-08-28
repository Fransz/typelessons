describe("An Task model", function () {

    describe("when newly created with letters 'gh'", function() {
        var task;
        var ls;

        beforeEach(function () {
            task = new TaskModel({letters: ['g', 'h']});
            ls = task.get('letters');
            completed = task.get('completed');
        });


        it("should have letters 'g', 'h' and ' '", function () {
            expect(ls).to.have.length(3);
            expect(ls).to.contain('g');
            expect(ls).to.contain('h');
            expect(ls).to.contain(' ');
        });

        it("should not be completed", function () {
            /* jshint -W030 */
            expect(completed).to.be.false;
        });

        it("should have weights 0.45 for 'g' and 'h', and 0.1 for ' ', as default", function() {
            ws = task.get('weights');
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0.1);
                else expect(e[1]).to.be.equal(0.45);
            });
        });

        it("should have weights 0.3 for 'g' and 'h', and 0.4 for ' ', if weights are generated with p = 0.4 for ' '", function() {
            ws = task.simpleWeights(0.4);
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0.4);
                else expect(e[1]).to.be.equal(0.3);
            });
        });

        it("should have weights 0.5 for 'g' and 'h', and 0 for ' ', if weights are generated with (p =< 0 || p >= 1) for ' '", function() {
            ws = task.simpleWeights(1);
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0);
                else expect(e[1]).to.be.equal(0.5);
            });

            ws = task.simpleWeights(-0.1);
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0);
                else expect(e[1]).to.be.equal(0.5);
            });
        });

        it("Should not have completed exams", function () {
            expect(task.get("exams")).to.have.length(0);
        });
    });

    describe("when passed an completed exam", function() {
        var exam, task;

        beforeEach(function () {
            task = new TaskModel({letters: ['g', 'h']});
            exam = new ExamModel({letters: ['g', 'h', ' '], weights: [0.25, 0.25, 0.5]});
            exam.set("completed", true);
        });

        it("Should add the given exam to the exam collection", function () {
            task.completeExam(exam);
            expect(task.get("exams")).to.have.length(1);
        });

    });
});
