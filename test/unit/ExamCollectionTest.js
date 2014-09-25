describe("An Exam collection", function () {

    describe("When newly created", function() {
        var collection;

        beforeEach(function () {
            collection = new App.ExamCollection();
        });

        it("should have a length of 0", function () {
            expect(collection.length).to.be.equal(0);
        });

        it("should have cummelative scores with all values 0", function() {
            ss = collection.sumScore();
            expect(ss.fail).to.be.equal(0);
            expect(ss.pass).to.be.equal(0);
            expect(ss.time).to.be.equal(0);
            expect(ss.tries).to.be.equal(0);
        });

        it("should have average scores with all values 0", function () {
            ss = collection.avgScore();
            expect(ss.fail).to.be.equal(0);
            expect(ss.pass).to.be.equal(0);
            expect(ss.time).to.be.equal(0);
        });

        it("should have last scores with all values 0", function () {
            ss = collection.lastScore();
            expect(ss.fail).to.be.equal(0);
            expect(ss.pass).to.be.equal(0);
            expect(ss.time).to.be.equal(0);
        });

    });

    describe("when having 4 completed exams for with letters 'gh '", function() {
        var collection;

        beforeEach(function () {
            var exam, scores;

            collection = new App.ExamCollection();
            scores = {
                'h': {pass: 20, fail: 25},
                'j': {pass: 20, fail: 25},
                ' ': {pass: 5, fail: 5},
            };
            for(var i = 0; i < 3; i++) {
                exam = new App.ExamModel({letters: ['g', 'h'], weights: [0.5, 0.5]});
                exam.set("scores", scores);
                exam.set("time", 100);
                collection.add(exam);
            }

            scores = {
                'h': {pass: 45, fail: 2},
                'j': {pass: 20, fail: 0},
                ' ': {pass: 0, fail: 13},
            };
            exam = new App.ExamModel({letters: ['g', 'h'], weights: [0.5, 0.5]});
            exam.set("scores", scores);
            exam.set("time", 20);
            collection.add(exam);
        });



        it("should have a length of 4", function () {
            expect(collection.length).to.be.equal(4);
        });

        it("should have the correct cummelative scores", function () {
            ss = collection.sumScore();
            expect(ss.pass).to.be.equal(200);
            expect(ss.fail).to.be.equal(180);
            expect(ss.time).to.be.equal(320);
            expect(ss.tries).to.be.equal(4);

        });

        it("should have the correct average scores", function () {
            ss = collection.avgScore();
            expect(ss.pass).to.be.equal(50);
            expect(ss.fail).to.be.equal(45);
            expect(ss.time).to.be.equal(80);

        });

        it("should have the correct last scores", function () {
            ss = collection.lastScore();
            expect(ss.pass).to.be.equal(65);
            expect(ss.fail).to.be.equal(15);
            expect(ss.time).to.be.equal(20);
        });
    });
 });

