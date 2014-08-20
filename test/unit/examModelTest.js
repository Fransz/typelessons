describe("An Exam model", function () {
    var exam;
    var ls;
    var ss;

    beforeEach(function () {
        exam = new ExamModel({letters: ['g', 'h']});
        ls = exam.get('letters');
        ss = exam.get('scores');
    })


    describe("when newly created with letters 'gh'", function() {
        it("should have letters 'g', 'h' and ' '", function () {
            expect(ls).to.have.length(3);
            expect(ls).to.contain('g');
            expect(ls).to.contain('h');
            expect(ls).to.contain(' ');
        });

        it("should have a duration of 0", function () {
            expect(exam.get('duration')).to.be.equal(0)
        });

        it("should have a zero pass entry and a zero fail entry, in scores for each letter", function () {
            for (i in ls) {
                expect(ss[ls[i]]).to.have.ownProperty('pass')
                expect(ss[ls[i]]['pass']).to.be.equal(0)
                expect(ss[ls[i]]).to.have.ownProperty('fail')
                expect(ss[ls[i]]['fail']).to.be.equal(0)
            }
        });

        it("should have a testString of length 100", function () {
            expect(exam.get("testString")).to.have.length(100);
        });

        it("should have an empty typedString", function () {
            expect(exam.get("typedString")).to.have.length(0);
        });

        it("should be able to generate a string with the given length, consisting only of our letters.", function () {
            var cs = ls.join('');
            var s = exam.mkString(100);

            expect(s).to.have.length(100);
            for(i in s) {
                expect(ls).to.contain(s[i])
            }
        });
    });

    describe("when created with letters 'gh', and having testString 'ghghgh  ghghgh' ", function() {
        var testString = "ghghgh  ghghgh";

        beforeEach(function () {
            testString = "ghghgh  ghghgh";
            exam.set("testString", testString)
        })

        it("should calculate scores for the first typed character correctly", function () {
            // Last typed 'h'
            exam.set("typedString", "h");
            exam.calcLastScore();

            expect(exam.get("lastScore")).to.be.equal("fail");
            expect(ss['g']['pass']).to.be.equal(0);
            expect(ss['g']['fail']).to.be.equal(1);
            expect(ss['h']['pass']).to.be.equal(0);
            expect(ss['h']['fail']).to.be.equal(0);
            expect(ss[' ']['pass']).to.be.equal(0);
            expect(ss[' ']['fail']).to.be.equal(0);

            // Last typed 'g'
            exam.set("typedString", "g");
            exam.calcLastScore();

            expect(exam.get("lastScore")).to.be.equal("pass");
            expect(ss['g']['pass']).to.be.equal(1);
            expect(ss['g']['fail']).to.be.equal(1);
            expect(ss['h']['pass']).to.be.equal(0);
            expect(ss['h']['fail']).to.be.equal(0);
            expect(ss[' ']['pass']).to.be.equal(0);
            expect(ss[' ']['fail']).to.be.equal(0);
        });

        it("should calculate scores for any typed character correctly", function () {
            // Last typed 'h'
            exam.set("typedString", "ghghghh");
            exam.calcLastScore();

            expect(exam.get("lastScore")).to.be.equal("fail");
            expect(ss['g']['pass']).to.be.equal(0);
            expect(ss['g']['fail']).to.be.equal(0);
            expect(ss['h']['pass']).to.be.equal(0);
            expect(ss['h']['fail']).to.be.equal(0);
            expect(ss[' ']['pass']).to.be.equal(0);
            expect(ss[' ']['fail']).to.be.equal(1);

            // Last typed ' '
            exam.set("typedString", "ghghgh ");
            exam.calcLastScore();

            expect(exam.get("lastScore")).to.be.equal("pass");
            expect(ss['g']['pass']).to.be.equal(0);
            expect(ss['g']['fail']).to.be.equal(0);
            expect(ss['h']['pass']).to.be.equal(0);
            expect(ss['h']['fail']).to.be.equal(0);
            expect(ss[' ']['pass']).to.be.equal(1);
            expect(ss[' ']['fail']).to.be.equal(1);
        });

        it("should calculate scores for the last typed character correctly", function () {
            // Last typed ' '
            exam.set("typedString", "ghghgh  ghghg ");
            exam.calcLastScore();

            expect(exam.get("lastScore")).to.be.equal("fail");
            expect(ss['g']['pass']).to.be.equal(0);
            expect(ss['g']['fail']).to.be.equal(0);
            expect(ss['h']['pass']).to.be.equal(0);
            expect(ss['h']['fail']).to.be.equal(1);
            expect(ss[' ']['pass']).to.be.equal(0);
            expect(ss[' ']['fail']).to.be.equal(0);

            // Last typed 'h'
            exam.set("typedString", "ghghgh  ghghgh");
            exam.calcLastScore();

            expect(exam.get("lastScore")).to.be.equal("pass");
            expect(ss['g']['pass']).to.be.equal(0);
            expect(ss['g']['fail']).to.be.equal(0);
            expect(ss['h']['pass']).to.be.equal(1);
            expect(ss['h']['fail']).to.be.equal(1);
            expect(ss[' ']['pass']).to.be.equal(0);
            expect(ss[' ']['fail']).to.be.equal(0);
        });

        it("should not add scores for the hit key", function () {
            // Last typed 'q'
            exam.set("typedString", "q");
            exam.calcLastScore();

            expect(ss['q']).to.be.undefined;

            // Last typed 'h'
            exam.set("typedString", "h");
            exam.calcLastScore();

            expect(ss['h']['pass']).to.be.equal(0);
            expect(ss['h']['fail']).to.be.equal(0);
        });


        it("should remember the last keystroke", function () {
            exam.addKeyStroke('x');

            expect(exam.get("lastChar")).to.be.equal("x");
            expect(exam.get("typedString")).to.be.equal("x");
        });
    });
 });
