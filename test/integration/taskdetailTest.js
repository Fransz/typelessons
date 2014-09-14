var expect = require('chai').expect,
    webdriver = require('/usr/local/lib/node_modules/selenium-webdriver'),
    SeleniumServer = require('/usr/local/lib/node_modules/selenium-webdriver/remote').SeleniumServer;

var mainUrl = "http://localhost/workspace/javascript/typelessons/typelessons.html",
    serverPath = "/usr/local/opt/selenium-server-standalone/libexec/selenium-server-standalone-2.42.2.jar";


describe("The task detail panel", function () {
    this.timeout(10000);

    before(function(done) {
        this.timeout = 15000;
        var server = new SeleniumServer(serverPath, {
            port: 4444
        });
        server.start();
        driver = new webdriver.Builder().
            usingServer(server.address()).
            withCapabilities(webdriver.Capabilities.htmlunit()).
            // withCapabilities(webdriver.Capabilities.firefox()).
            build();

        driver.get(mainUrl);
        done();
    });

    after(function(done) { 
      driver.quit().then(done);
    });

    it("should be non visible on startup.", function (done) {
        driver.findElements(webdriver.By.id("taskdetail")).then(function(elms) {
            /* jshint -W030 */
            expect(elms).to.have.length(1);

            elm = elms[0];
            elm.isDisplayed().then(function(val) {
                expect(val).to.be.false;
            });
        }).then(done);
    });

    it("should be opened by clicking on a 8lettertask", function (done) {
        driver.findElements(webdriver.By.id("8lettertasks")).then(function(elms) {
            /* jshint -W030 */
            elm = elms[0];
            expect(elm).to.exist;

            elm.findElements(webdriver.By.className("task")).then(function(elms) {
                var task = elms[0];
                task.click().then(function() {
                    driver.findElements(webdriver.By.id("taskdetail")).then(function(elms) {
                        elm = elms[0];
                        elm.isDisplayed().then(function(val) {
                            expect(val).to.be.true;
                        });
                    });
                });
            });
        }).then(done);
    });

    describe("#when opened", function(done) {
        it("should show 8 letters, and a space", function (done) {
            /* scrape the weights text from the detail view, compare these with the scraped weights from the taskview*/

            /* jshint -W083, -W030 */
            var detailLetters;

            function detailTest(text) {
                    text = text.replace("letters", "");
                    text = text.replace(/\n/g, "");
                    detailLetters = text;
                    expect(detailLetters).to.have.length(9);
            }
            function detailText(cb) {
                return function(keyRows) {
                    keyRows[0].getText().then(cb);
                };
            }
            function detailKeyRows(cb) {
                return function (taskDetails) {
                    taskDetails[0].findElements(webdriver.By.className("keyrow")).then(cb);
                };
            }

            function taskTest(text) {
                text = text.replace(/\n/g, "");
                for(var i = 0, l = text.length; i < l; i++) {
                        expect(detailLetters).to.contain(text[i]);
                }
            }
            function taskText(cb) {
                return function(keyRows) {
                    keyRows[0].getText().then(cb);
                };
            }
            function taskKeyRows (cb) {
                return function (tasks) {
                    tasks[0].findElements(webdriver.By.className("keyrow")).then(cb);
                };
            }
            function taskTasks (cb) {
                return function (lettertasks) {
                    lettertasks[0].findElements(webdriver.By.className("task")).then(cb);
                };
            }


            driver.findElements(webdriver.By.id("taskdetail")).then(
                        detailKeyRows(detailText(detailTest))
                    ).then(
                        function() {
                            driver.findElements(webdriver.By.id("8lettertasks")).then(
                                taskTasks(taskKeyRows(taskText(taskTest)))
                    );
            }).then(done);
        });

        it("should show 9 weights", function (done) {
            function detailTest(weights) {
                expect(weights).to.have.length(9);
            }

            function detailWeights(cb) {
                return function (details) {
                    details[0].findElements(webdriver.By.className("weight")).then(cb);
                };
            }

            driver.findElements(webdriver.By.id("taskdetail")).then(
                    detailWeights(detailTest)
                ).then(done);
        });

        it.skip("should show the number of tries", function (done) {
        });

        it.skip("should show total scores", function (done) {
        });

        it.skip("should show average scores", function (done) {
        });

        it.skip("should show last scores", function (done) {
        });

        it.skip("should have a remove button", function (done) {
        });

        it.skip("should have a exam button", function (done) {
        });
    });
});
