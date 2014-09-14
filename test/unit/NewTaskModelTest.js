describe("An New Task model", function () {
    describe("upon creation", function () {
        before(function () {
            newTask = new App.NewTaskModel();
        });

        it("should have one letter, 'space'", function() {
            /* jshint -W030 , -W069*/
            expect(_.size(newTask.get("letters"))).to.be.equal(1);
            expect(newTask.get("letters")['space']).to.exist;
        });

        it("should be able to add a letters", function() {
            /* jshint -W030, -W069 */
            newTask.addLetter("a");

            expect(newTask.get("letters")["space"]).to.exist;
            expect(newTask.get("letters")['a']).to.exist;
            expect(_.size(newTask.get("letters"))).to.be.equal(2);
        });

        it("should be able to delete a letter" , function () {
            /* jshint -W030, -W069 */
            newTask.addLetter("a");
            newTask.deleteLetter("a");

            expect(newTask.get("letters")["space"]).to.exist;
            expect(newTask.get("letters")['a']).to.not.exist;
            expect(_.size(newTask.get("letters"))).to.be.equal(1);
        });

        it("should not be able to add the same letter again, the weight should stay the same", function() {
            /* jshint -W030, -W069 */
            ls = newTask.get("letters");
            ls["a"] = 0.9;
            newTask.set("letters", ls);
            newTask.addLetter("a");

            expect(newTask.get("letters")["space"]).to.exist;
            expect(newTask.get("letters")["a"]).to.exist;
            expect(_.size(newTask.get("letters"))).to.be.equal(2);
            expect(newTask.get("letters")["a"]).to.be.equal(0.9);
        });

        it("should not be able to the space character", function() {
            /* jshint -W030, -W069 */
            newTask.addLetter(" ");
            expect(newTask.get("letters")[" "]).to.not.exist;
            expect(newTask.get("letters")["space"]).to.exist;
            expect(newTask.get("letters")["a"]).to.exist;
            expect(_.size(newTask.get("letters"))).to.be.equal(2);
        });
    });

    describe("adding a letter and weight pair", function () {
        before(function () {
            newTask = new App.NewTaskModel();
        });

        it("should not be possible if the weight is not a numerical string", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "zero.nine");
            expect(newTask.get("letters")["a"]).to.not.exist;
            expect(r).to.be.false;

            r = newTask.addWeight('a', "");
            expect(newTask.get("letters")["a"]).to.not.exist;
            expect(r).to.be.false;
        });

        it("should not possible to if the weight is 1", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "1.2");
            expect(newTask.get("letters")["a"]).to.not.exist;
            expect(r).to.be.false;
        });

        it("should not possible to if there is no letter", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('', "0.2");
            expect(r).to.be.false;
        });

        it("should be possible if all weights count up to one.", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.9");
            expect(newTask.get("letters")["a"]).to.exist;
            expect(r).to.be.true;
        });

        it("should be possible to if all weights dont count up to one, but with an error", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.2");
            expect(newTask.get("letters")["a"]).to.exist;
            expect(r).to.be.false;
        });

        it("should return even generated weight which sum up to (1 - 0.1)", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.9");
            r = newTask.addWeight('b', "0.9");
            newTask.evenWeights();

            ls = newTask.get("letters");
            ws = _.filter(ls, function(v, k) { return k !== "space"; });
            space = ls['space'];

            v = _.reduce(ws, function(m, v) { return m + v; }, 0);
            expect(v).to.be.equal(1 - space);
        });

        it("should have the same even generated weight for each letter", function () {
            /* jshint -W030 */
            r = newTask.addWeight('a', "0.9");
            r = newTask.addWeight('b', "0.9");
            newTask.evenWeights();

            ls = newTask.get("letters");
            ws = _.filter(ls, function(v, k) { return k !== "space"; });
            expect(ws[0]).to.be.equal(ws[1]);
        });


        it("should be able to ask for the weight of a letter", function () {
            /* jshint -W069 */
            r = newTask.addWeight('a', "0.1");
            r = newTask.addWeight('b', "0.9");

            expect(newTask.getWeight("b")).to.be.equal(0.9);
        });

        it("should return undefined if asked the weight of a letter not added", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.1");
            r = newTask.addWeight('b', "0.9");

            expect(newTask.getWeight("c")).to.be.undefined;
        });
    });

    describe("upon submission", function () {
        beforeEach(function () {
            newTask = new App.NewTaskModel();
        });

        it("should validate with 3 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.45");
            r = newTask.addWeight('b', "0.45");
            expect(newTask.isValid()).to.be.true;
        });

        it("should validate with 5 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.225");
            r = newTask.addWeight('b', "0.225");
            r = newTask.addWeight('c', "0.225");
            r = newTask.addWeight('d', "0.225");
            expect(newTask.isValid()).to.be.true;
        });

        it("should validate with 7 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.15");
            r = newTask.addWeight('b', "0.15");
            r = newTask.addWeight('c', "0.15");
            r = newTask.addWeight('d', "0.15");
            r = newTask.addWeight('e', "0.15");
            r = newTask.addWeight('f', "0.15");
            expect(newTask.isValid()).to.be.true;
        });

        it("should validate with 9 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.1125");
            r = newTask.addWeight('b', "0.1125");
            r = newTask.addWeight('c', "0.1125");
            r = newTask.addWeight('d', "0.1125");
            r = newTask.addWeight('e', "0.1125");
            r = newTask.addWeight('f', "0.1125");
            r = newTask.addWeight('g', "0.1125");
            r = newTask.addWeight('h', "0.1125");
            expect(newTask.isValid()).to.be.true;
        });

        it("should not validate with 3 letters, none of which is space", function () {
            /* jshint -W030, -W069 */
            newTask.deleteLetter('space');

            r = newTask.addWeight('s', "0.1");
            r = newTask.addWeight('a', "0.45");
            r = newTask.addWeight('b', "0.45");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 5 letters, none of which is space", function () {
            /* jshint -W030, -W069 */
            newTask.deleteLetter('space');

            r = newTask.addWeight('s', "0.1");
            r = newTask.addWeight('a', "0.225");
            r = newTask.addWeight('b', "0.225");
            r = newTask.addWeight('c', "0.225");
            r = newTask.addWeight('d', "0.225");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 7 letters, none of which is space", function () {
            /* jshint -W030, -W069 */
            newTask.deleteLetter('space');

            r = newTask.addWeight('s', "0.1");
            r = newTask.addWeight('a', "0.15");
            r = newTask.addWeight('b', "0.15");
            r = newTask.addWeight('c', "0.15");
            r = newTask.addWeight('d', "0.15");
            r = newTask.addWeight('e', "0.15");
            r = newTask.addWeight('f', "0.15");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 9 letters, none of which is space", function () {
            /* jshint -W030, -W069 */
            newTask.deleteLetter('space');

            r = newTask.addWeight('s', "0.1");
            r = newTask.addWeight('a', "0.1125");
            r = newTask.addWeight('b', "0.1125");
            r = newTask.addWeight('c', "0.1125");
            r = newTask.addWeight('d', "0.1125");
            r = newTask.addWeight('e', "0.1125");
            r = newTask.addWeight('f', "0.1125");
            r = newTask.addWeight('g', "0.1125");
            r = newTask.addWeight('h', "0.1125");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 2 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('b', "0.9");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 4 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('b', "0.3");
            r = newTask.addWeight('c', "0.3");
            r = newTask.addWeight('d', "0.3");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 6 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('b', "0.2");
            r = newTask.addWeight('c', "0.2");
            r = newTask.addWeight('d', "0.2");
            r = newTask.addWeight('e', "0.2");
            r = newTask.addWeight('f', "0.2");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 8 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('b', "0.129");
            r = newTask.addWeight('c', "0.129");
            r = newTask.addWeight('d', "0.129");
            r = newTask.addWeight('e', "0.129");
            r = newTask.addWeight('f', "0.129");
            r = newTask.addWeight('g', "0.129");
            r = newTask.addWeight('h', "0.129");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate with 10 letters, one of which is space", function () {
            /* jshint -W030, -W069 */
            r = newTask.addWeight('a', "0.45");
            r = newTask.addWeight('b', "0.45");
            r = newTask.addWeight('c', "0.225");
            r = newTask.addWeight('d', "0.225");
            r = newTask.addWeight('e', "0.15");
            r = newTask.addWeight('f', "0.15");
            r = newTask.addWeight('g', "0.1125");
            r = newTask.addWeight('h', "0.1125");
            r = newTask.addWeight('i', "0.1125");
            expect(newTask.isValid()).to.be.false;
        });

        it("should not validate when the weights dont count up to one", function () {
            /*jshint -W030 */
            r = newTask.addWeight('a', "0.1");
            r = newTask.addWeight('b', "0.25");
            r = newTask.addWeight('c', "0.2");
            r = newTask.addWeight('d', "0.03");
            r = newTask.addWeight('e', "0.12");
            r = newTask.addWeight('f', "0.3");
            r = newTask.addWeight('space', "0.3");

            expect(newTask.isValid()).to.be.false;
        });

        it.skip("should not validate when a task with the same letters is already known", function () {

        });
    });
});
