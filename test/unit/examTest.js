describe("An Exam model", function () {

    describe("when created with letters 'gh'", function() {
        var exam = new ExamModel({letters: ['g', 'h']});

        it("should have letters 'g', 'h' and ' '", function () {
            var l = exam.get('letters');
            expect(l).to.have.length(3);
            expect(l).to.contain('g');
            expect(l).to.contain('h');
            expect(l).to.contain(' ');
        });

        it("should have a duration of 0", function () {
            expect(exam.get('duration')).to.be.equal(0)
        });

        it("should have a zero pass entry and a zero fail entry, in scores for each letter", function () {
            var ls = exam.get('letters');
            var ss = exam.get('scores');
            for (l in ls) {
                expect(ss[ls[l]]).to.have.ownProperty('pass')
                expect(ss[ls[l]]['pass']).to.be.equal(0)
                expect(ss[ls[l]]).to.have.ownProperty('fail')
                expect(ss[ls[l]]['fail']).to.be.equal(0)
            }
        });

        it.skip("should be able to generate a string with the given length", function () {
        });

        it.skip("should be able to generate a string with just 'gh '", function () {

        });
    });
 })
