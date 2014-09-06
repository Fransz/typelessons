// jshint ignore: start

"use strict"

var gulp = require('gulp'),
    util = require('gulp-util'),
    coffee = require('gulp-coffee'),
    less = require('gulp-less'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    livereload = require('gulp-livereload'),
    sourcemaps = require('gulp-sourcemaps'),
    mocha = require('gulp-mocha'),
    mochaPhantomJs = require('gulp-mocha-phantomjs'),
    del = require('del'),

    path = require('path');

var paths = {
    src: ['src/models/**/*.coffee', 'src/collections/**/*.coffee', 'src/views/**/*.coffee', 'src/**/*.coffee'],
    style: ['src/less/**/typelessons.less'],
    build: ['build/js'],
    test: {
        integration: ['test/integration/**/*'], unit: ['test/unit/**/testrunner.html']
    },
};



gulp.task('clean-js', function(cb) {
  del(['build/js/**/*', 'dist/js/**/*'], cb);
});

gulp.task('clean-css', function(cb) {
  del(['build/css/**/*', 'dist/css/**/*'], cb);
});

gulp.task('clean', ['clean-js', 'clean-css'], function () {
});


gulp.task('build', ['clean-js'], function() {
    return gulp.src(paths.src)
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true})).on('error', util.log)
        .pipe(concat('typelessons.js'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('build/js'));
});

gulp.task('style', ['clean-css'], function () {
    return gulp.src(paths.style)
        .pipe(sourcemaps.init())
        .pipe(less({
            paths: [ path.join(__dirname, "src", "less", "bootstrap")],
        }))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('build/css'))
});


gulp.task('integrationtest', function () {
    return gulp.src(paths.test.integration, {read: false})
        .pipe(mocha());
});


gulp.task('unittest', function () {
    return gulp.src(paths.test.unit)
        .pipe(mochaPhantomJs());
});


gulp.task('test', ['build', 'unittest', 'integrationtest'], function () {
});


gulp.task('dist', ['clean'], function() {
    return gulp.src(paths.src)
        .pipe(sourcemaps.init())
        .pipe(coffee())
        .pipe(concat('typelessons.js'))
        .pipe(uglify())
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('build/js'));
});


gulp.task('compress', function() {
  gulp.src('build/**/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('dist'));
});


gulp.task('watch', function() {
  livereload.listen();
  gulp.watch(paths.src, ['build']).on('change', livereload.changed);
  gulp.watch(paths.style, ['style']).on('change', livereload.changed);
});

// The default task (called when you run `gulp` from cli)
 gulp.task('default', ['watch', 'build']);
