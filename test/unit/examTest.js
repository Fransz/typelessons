describe("An Exam model", function () {

    describe("when created with letters 'gh'", function() {
        var exam = new ExamModel({letters: ['g', 'h']});

        it("should have letters 'g', 'h' and ' '", function () {
            var ls = exam.get('letters');

            expect(ls).to.have.length(3);
            expect(ls).to.contain('g');
            expect(ls).to.contain('h');
            expect(ls).to.contain(' ');
        });

        it("should have a duration of 0", function () {
            expect(exam.get('duration')).to.be.equal(0)
        });

        it("should have a zero pass entry and a zero fail entry, in scores for each letter", function () {
            var ls = exam.get('letters');
            var ss = exam.get('scores');

            for (i in ls) {
                expect(ss[ls[i]]).to.have.ownProperty('pass')
                expect(ss[ls[i]]['pass']).to.be.equal(0)
                expect(ss[ls[i]]).to.have.ownProperty('fail')
                expect(ss[ls[i]]['fail']).to.be.equal(0)
            }
        });

        it("should be able to generate a string with the given length, consisting only of our letters.", function () {
            var ls = exam.get('letters').join('');

            var s = exam.mkString(100);
            expect(s).to.have.length(100);

            for(i in s) {
                expect(ls).to.contain(s[i])
            }
        });

    });
 })
