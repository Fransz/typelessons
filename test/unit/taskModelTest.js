describe("An Task model", function () {

    describe("when newly created with letters 'gh'", function() {
        var task, ls, completed;

        beforeEach(function () {
            task = new App.TaskModel({letters: ['g', 'h']});
            ls = task.get('letters');
            completed = task.get('completed');
        });


        it("should have letters 'g', 'h' and ' '", function () {
            expect(ls).to.have.length(3);
            expect(ls).to.contain('g');
            expect(ls).to.contain('h');
            expect(ls).to.contain(' ');
        });

        it("should have letters ' ', at the final position of the letter array", function () {
            expect(ls[ls.length - 1]).to.be.equal(' ');
        });

        it("should not be completed", function () {
            /* jshint -W030 */
            expect(completed).to.be.false;
        });

        it("Should not have completed exams", function () {
            expect(task.get("exams")).to.have.length(0);
        });
        describe("its weights", function () {

            it("should be 0.45 for 'g' and 'h', and 0.1 for ' ', as default", function() {
                var ws = task.get('weights');
                var space = 1 - _.reduce(ws.slice(0, -1), function(m, v) { return m + v; }, 0);

                _.each(_.zip(ls, ws), function (e, i, l) {
                    if (e[0] == ' ') expect(e[1]).to.be.equal(space);
                    else expect(e[1]).to.be.equal(0.45);
                });
            });

            it("should be 0.3 for 'g' and 'h', and 0.4 for ' ', if weights are generated with p = 0.4 for ' '", function() {
                var ws = task.simpleWeights(0.4);
                _.each(_.zip(ls, ws), function (e, i, l) {
                    if (e[0] == ' ') expect(e[1]).to.be.equal(0.4);
                    else expect(e[1]).to.be.equal(0.3);
                });
            });

            it("should be 0.5 for 'g' and 'h', and 0 for ' ', if weights are generated with (p =< 0 || p >= 1) for ' '", function() {
                var ws = task.simpleWeights(1);
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

            it("should have defaults overriden if passed an weights array on creation", function () {
                var ws = ['0.1', '0.2', '0.4'];
                var task = new App.TaskModel({letters: ['g', 'h'], weights: ws});
                var ws_ = task.get("weights");

                expect(ws_).to.be.equal(ws);
            });
        });
    });

    describe("when passed an completed exam", function() {
        var exam, task, taskCollection, localStorage;

        before(function () {
            task = new App.TaskModel({letters: ['g', 'h']});
            task.localStorage = new Backbone.LocalStorage("typelessons_test.tasks");

            taskCollection = new App.TaskCollection();
            taskCollection.localStorage = new Backbone.LocalStorage("typelessons_test.tasks");

            localStorage = task.localStorage.localStorage();

            exam = new App.ExamModel({letters: ['g', 'h', ' '], weights: [0.25, 0.25, 0.5]});
            exam.set("completed", true);

            task.completeExam(exam);
        });

        after(function() {
            var keys = localStorage.getItem("typelessons_test.tasks").split(",");

            for(var i = 0, l = keys.length; i < l; i++) {
                var value = localStorage.getItem("typelessons_test.tasks" + '-' + keys[i]);
                localStorage.removeItem("typelessons_test.tasks" + '-' + keys[i]);
            }
            localStorage.removeItem("typelessons_test.tasks");
        });

        it("should add the given exam to the exam collection", function () {
            expect(task.get("exams")).to.have.length(1);
        });

        it("should be saved in storage", function () {
            keys = localStorage.getItem("typelessons_test.tasks").split(",");
            expect(keys).to.have.length(1);

            item = JSON.parse(localStorage.getItem("typelessons_test.tasks" + '-' + keys[0]));
            expect(item.id).to.be.equal(task.get("id"));
        });

        it("should be retrievable from storage", function () {
            task.set("letters", []);
            task.fetch();
            
            var ls = task.get("letters");

            expect(ls).to.contain('h');
            expect(ls).to.contain('g');
            expect(ls).to.contain(' ');
        });

    });
});
