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
        done()
    });

    after(function(done) { 
      driver.quit().then(done);
    })


    describe("#when opened", function(done) {
         this.timeout(10000)

         it("should have title 'typelessons'.", function (done) {
             driver.get(mainUrl);
             driver.wait(function() {
                 driver.getTitle().then(function(title) {
                     expect(title).to.have.string('typelessons');
                 }).then(done);
            }, 5000);
        });

         it("should have one element with id 'text' which has no content.", function (done) {
             driver.wait(function() {
                 driver.findElements(webdriver.By.id("text")).then(function(elms) {
                     expect(elms).to.have.length(1);

                     elms[0].getInnerHtml().then(function (content) {
                         expect(content).to.be.empty
                     });
                 }).then(done);
             }, 5000);
         });

         it("should have an element with id 'typed' which has no content.", function (done) {
             driver.wait(function() {
                 driver.findElements(webdriver.By.id("typed")).then(function(elms) {
                     expect(elms).to.have.length(1);

                     elms[0].getInnerHtml().then(function (content) {
                         expect(content).to.be.empty
                     });
                 }).then(done);
             }, 5000);
         });
     }) 
 })
