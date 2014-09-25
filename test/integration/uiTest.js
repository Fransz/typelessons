// This test suite should be tested under nodejs
//
// mocha test/integration/ui.js

var expect = require('chai').expect,
    webdriver = require('/usr/local/lib/node_modules/selenium-webdriver'),
    SeleniumServer = require('/usr/local/lib/node_modules/selenium-webdriver/remote').SeleniumServer;

var mainUrl = "http://localhost/workspace/javascript/typelessons/typelessons.html",
    serverPath = "/usr/local/opt/selenium-server-standalone/libexec/selenium-server-standalone-2.42.2.jar";


describe("User Interface", function () {

    before(function(done) {
        this.timeout = 15000;
        var server = new SeleniumServer(serverPath, {
            port: 4444
        });
        server.start();
        driver = new webdriver.Builder().
            usingServer(server.address()).
            withCapabilities(webdriver.Capabilities.htmlunit()).
            build();
        done();
    });

    after(function(done) { 
      driver.quit().then(done);
    });


    describe("#when opened", function(done) {
         this.timeout(10000);

         it.skip("should have title 'typelessons'.", function (done) {
             driver.get(mainUrl);
             driver.wait(function() {
                 driver.getTitle().then(function(title) {
                     expect(title).to.have.string('typelessons');
                 }).then(done);
            }, 5000);
        });

         it.skip("should have one element with id 'exam'.", function (done) {
             driver.wait(function() {
                /* jshint -W030 , -W069*/
                 driver.findElements(webdriver.By.id("exam")).then(function(elms) {
                     expect(elms).to.have.length(1);
                 }).then(done);
             }, 5000);
         });

         it.skip("should have an element with id 'taskdetail'.", function (done) {
            driver.wait(function() {
                /* jshint -W030 , -W069*/
                driver.findElements(webdriver.By.id("taskdetail")).then(function(elms) {
                    expect(elms).to.have.length(1);
                }).then(done);
            }, 5000);
        });
    });
 });
