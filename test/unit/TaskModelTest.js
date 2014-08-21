describe("An Task model", function () {

    describe("when newly created with letters 'gh'", function() {
        var task;
        var ls;

        beforeEach(function () {
            task = new TaskModel({letters: ['g', 'h']});
            ls = task.get('letters');
        })


        it("should have letters 'g', 'h' and ' '", function () {
            expect(ls).to.have.length(3);
            expect(ls).to.contain('g');
            expect(ls).to.contain('h');
            expect(ls).to.contain(' ');
        });

        it("should have weights 0.45 for 'g' and 'h', and 0.1 for ' ', as default", function() {
            ws = task.get('weights');
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0.1)
                else expect(e[1]).to.be.equal(0.45)
            })
        });

        it("should have weights 0.3 for 'g' and 'h', and 0.4 for ' ', if weights are generated with p = 0.4 for ' '", function() {
            ws = task.calcSimpleWeights(0.4);
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0.4)
                else expect(e[1]).to.be.equal(0.3)
            })
        });

        it("should have weights 0.5 for 'g' and 'h', and 0 for ' ', if weights are generated with p =< 0 || p >= 1 for ' '", function() {
            ws = task.calcSimpleWeights(1);
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0)
                else expect(e[1]).to.be.equal(0.5)
            })

            ws = task.calcSimpleWeights(-0.1);
            _.each(_.zip(ls, ws), function (e, i, l) {
                if (e[0] == ' ') expect(e[1]).to.be.equal(0)
                else expect(e[1]).to.be.equal(0.5)
            })
        });
    });
});
