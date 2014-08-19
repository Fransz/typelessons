'use strict';

var gulp = require('gulp'),
    util = require('gulp-util'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    livereload = require('gulp-livereload'),
    sourcemaps = require('gulp-sourcemaps'),
    mocha = require('gulp-mocha'),
    mochaPhantomJs = require('gulp-mocha-phantomjs'),
    del = require('del');

var paths = {
    src: ['src/**/*'],
    build: ['build/js'],
    test: {
        integration: ['test/integration/**/*'], unit: ['test/unit/**/testrunner.html']
    },
};



gulp.task('clean', function(cb) {
  del(['build/**/*', 'dist/**/*'], cb);
});


gulp.task('build', ['clean'], function() {
    return gulp.src(paths.src)
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true})).on('error', util.log)
        .pipe(concat('typelessons.js'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('build/js'));
});


gulp.task('test_integration', function () {
    return gulp.src(paths.test.integration, {read: false})
        .pipe(mocha());
});


gulp.task('test_unit', function () {
    return gulp.src(paths.test.unit)
        .pipe(mochaPhantomJs());
});


gulp.task('test', ['build', 'test_unit', 'test_integration'], function () {
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
    .pipe(gulp.dest('dist'))
});


gulp.task('watch', function() {
  livereload.listen();
  gulp.watch(paths.src, ['build']).on('change', livereload.changed);
});

// The default task (called when you run `gulp` from cli)
 gulp.task('default', ['watch', 'build']);
