/* jshint -W069, -W030 */

describe("An Exam model", function () {

    describe("when newly created with letters 'gh ', and no weigths", function() {
        var exam;
        var ls;
        var ss;

        beforeEach(function () {
            exam = new App.ExamModel({letters: ['g', 'h', ' '], weights: [0.25, 0.25, 0.5]});
        });

        it("should have an attribute letters, equal to the letters given upon creation", function () {
            expect(exam.get("letters")).to.be.eql(['g', 'h', ' ']);
        });

        it("should have an attribute weights, equal to the weights given upon creation", function () {
            expect(exam.get("weights")).to.be.eql([0.25, 0.25, 0.5]);
        });

        it("should have a time of 0", function () {
            expect(exam.get("time")).to.be.equal(0);
        });

        it("should have a zero pass entry and a zero fail entry, in scores for each letter", function () {
            var ls = exam.get("letters");
            var ss = exam.get("scores");
            for (var i in ls) {
                expect(ss[ls[i]]).to.have.ownProperty("pass");
                expect(ss[ls[i]].pass).to.be.equal(0);
                expect(ss[ls[i]]).to.have.ownProperty("fail");
                expect(ss[ls[i]].fail).to.be.equal(0);
            }
        });

        it("should have an empty typedString", function () {
            expect(exam.get("typedString")).to.have.length(0);
        });

        describe("the teststing", function () {
            it("should have a length of 100", function () {
                expect(exam.get("testString")).to.have.length(100);
            });

            it("should only consist of our characters", function () {
                var cs = exam.get("letters").join('');
                var s = exam.get("testString");

                for(var i in s) {
                    expect(cs).to.contain(s[i]);
                }
            });

            it("should not start, or end with ' ' ", function () {
                var s = exam.get("testString");
                expect(s[0]).to.be.not.equal(' ');
            });

            it("should not contain double ' ' ", function () {
                var s = exam.get("testString");
                var re = /  +/;
                expect(re.test(s)).to.be.false;
            });
        });
    });
    

    describe("when created with letters 'gh ', and having testString 'ghghgh ghghgh' ", function() {
        var exam;
        var ls;
        var ss;
        var testString = "ghghgh ghghgh";

        beforeEach(function () {
            exam = new App.ExamModel({letters: ['g', 'h', ' '], weights: [0.25, 0.25, 0.5]});
            ls = exam.get("letters");
            ss = exam.get("scores");
           
            exam.set("testString", testString);
        });

        it("should calculate scores for the first typed character", function () {
            // Last typed 'h'
            exam.set("typedString", "h");
            exam.lastScore();

            expect(exam.get("lastScore")).to.be.equal("fail");
            expect(ss['g']["pass"]).to.be.equal(0);
            expect(ss['g']["fail"]).to.be.equal(1);
            expect(ss['h']["pass"]).to.be.equal(0);
            expect(ss['h']["fail"]).to.be.equal(0);
            expect(ss[' ']["pass"]).to.be.equal(0);
            expect(ss[' ']["fail"]).to.be.equal(0);

            // Last typed 'g'
            exam.set("typedString", "g");
            exam.lastScore();

            expect(exam.get("lastScore")).to.be.equal("pass");
            expect(ss['g']["pass"]).to.be.equal(1);
            expect(ss['g']["fail"]).to.be.equal(1);
            expect(ss['h']["pass"]).to.be.equal(0);
            expect(ss['h']["fail"]).to.be.equal(0);
            expect(ss[' ']["pass"]).to.be.equal(0);
            expect(ss[' ']["fail"]).to.be.equal(0);
        });

        it("should calculate scores for any typed character", function () {
            // Last typed 'h'
            exam.set("typedString", "ghghghh");
            exam.lastScore();

            expect(exam.get("lastScore")).to.be.equal("fail");
            expect(ss['g']["pass"]).to.be.equal(0);
            expect(ss['g']["fail"]).to.be.equal(0);
            expect(ss['h']["pass"]).to.be.equal(0);
            expect(ss['h']["fail"]).to.be.equal(0);
            expect(ss[' ']["pass"]).to.be.equal(0);
            expect(ss[' ']["fail"]).to.be.equal(1);

            // Last typed ' '
            exam.set("typedString", "ghghgh ");
            exam.lastScore();

            expect(exam.get("lastScore")).to.be.equal("pass");
            expect(ss['g']["pass"]).to.be.equal(0);
            expect(ss['g']["fail"]).to.be.equal(0);
            expect(ss['h']["pass"]).to.be.equal(0);
            expect(ss['h']["fail"]).to.be.equal(0);
            expect(ss[' ']["pass"]).to.be.equal(1);
            expect(ss[' ']["fail"]).to.be.equal(1);
        });

        it("should calculate scores for the last typed character", function () {
            // Last typed ' '
            exam.set("typedString", "ghghgh ghghg ");
            exam.lastScore();

            expect(exam.get("lastScore")).to.be.equal("fail");
            expect(ss['g']["pass"]).to.be.equal(0);
            expect(ss['g']["fail"]).to.be.equal(0);
            expect(ss['h']["pass"]).to.be.equal(0);
            expect(ss['h']["fail"]).to.be.equal(1);
            expect(ss[' ']["pass"]).to.be.equal(0);
            expect(ss[' ']["fail"]).to.be.equal(0);

            // Last typed 'h'
            exam.set("typedString", "ghghgh ghghgh");
            exam.lastScore();

            expect(exam.get("lastScore")).to.be.equal("pass");
            expect(ss['g']["pass"]).to.be.equal(0);
            expect(ss['g']["fail"]).to.be.equal(0);
            expect(ss['h']["pass"]).to.be.equal(1);
            expect(ss['h']["fail"]).to.be.equal(1);
            expect(ss[' ']["pass"]).to.be.equal(0);
            expect(ss[' ']["fail"]).to.be.equal(0);
        });

        it("should not add scores for the wrongly hit key", function () {
            // Last typed 'q'
            exam.set("typedString", "q");
            exam.lastScore();

            expect(ss['q']).to.be.undefined;

            // Last typed 'h'
            exam.set("typedString", "h");
            exam.lastScore();

            expect(ss['h']["pass"]).to.be.equal(0);
            expect(ss['h']["fail"]).to.be.equal(0);
        });


        it("should remember the last keystroke", function () {
            exam.addKeyStroke('x');

            expect(exam.get("lastChar")).to.be.equal("x");
            expect(exam.get("typedString")).to.be.equal("x");
        });

        it("should calculate total scores", function () {
            _.forEach("hghghg ghghgh", function (e, i, l) { exam.addKeyStroke(e); });
            total = exam.totalScore();

            expect(total.pass).to.be.equal(7);
            expect(total.fail).to.be.equal(6);
        });

        it("should be marked complete after typing 13 characters", function () {
            _.forEach("hghghg ghghg", function (e, i, l) { exam.addKeyStroke(e); });
            expect(exam.get("completed")).to.be.false;

            exam.addKeyStroke('h');
            expect(exam.get("completed")).to.be.true;
        });

        it("should have a score of 13 after typing 13 characters, and being marked complete", function () {
            _.forEach("hghghg ghghgh", function (e, i, l) { exam.addKeyStroke(e); });

            var s = exam.totalScore();
            expect(s.fail + s.pass).to.be.equal(13);
        });
    });
 });
