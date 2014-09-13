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

    it("should have non visible element 'taskdetail'.", function (done) {
        driver.wait(function() {
            /* jshint -W030 */
            driver.findElements(webdriver.By.id("taskdetail")).then(function(elms) {
                expect(elms).to.have.length(1);

                elm = elms[0];
                elm.isDisplayed().then(function(val) {
                    expect(val).to.be.false;
                });
            }).then(done);
        }, 5000);
    });

    it("should be opened by clicking on a task", function (done) {
        driver.wait(function() {
            /* jshint -W030 */
            driver.findElements(webdriver.By.id("8lettertasks")).then(function(elms) {
                elm = elms[0];
                expect(elm).to.exist;

                elm.findElements(webdriver.By.className("task")).then(function(elms) {
                    var task;
                    task = elms[0];
                    task.click().then(function() {
                        driver.findElements(webdriver.By.id("taskdetail")).then(function(elms) {
                            elm = elms[0];
                            elm.isDisplayed().then(function(val) {
                                expect(val).to.be.true;
                            });
                        });
                    });
                }).then(done);
            });
        }, 5000);
    });

    describe("#when opened", function(done) {
    });
});
