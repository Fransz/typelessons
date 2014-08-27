describe("An Exam collection", function () {

    describe("When newly created", function() {
        var collection;

        beforeEach(function () {
            collection = new ExamCollection();
        });

        it("should have a length of 0", function () {
            expect(collection.length).to.be.equal(0);
        });

        it("should have cummelative scores with all values 0", function() {
            ss = collection.cummScore();
            expect(ss.fail).to.be.equal(0);
            expect(ss.pass).to.be.equal(0);
            expect(ss.time).to.be.equal(0);
            expect(ss.tries).to.be.equal(0);
        });

    });

    describe("when having 3 completed exams for with letters 'gh '", function() {
        var collection;

        beforeEach(function () {
            var exam, scores;

            collection = new ExamCollection();
            scores = {
                'h': {pass: 20, fail: 25},
                'j': {pass: 20, fail: 25},
                ' ': {pass: 5, fail: 5},
            };
            for(var i = 0; i < 3; i++) {
                exam = new ExamModel({letters: ['g', 'h']});
                exam.set("scores", scores);
                exam.set("time", 100);
                collection.add(exam);
            }
        });

        it("should have a length of 3", function () {
            expect(collection.length).to.be.equal(3);
        });

        it("should have the correct cummelative scores", function () {
            ss = collection.cummScore();
            console.log(ss);
            expect(ss.fail).to.be.equal(165);
            expect(ss.pass).to.be.equal(135);
            expect(ss.time).to.be.equal(300);
            expect(ss.tries).to.be.equal(3);

        });
    });
 });

