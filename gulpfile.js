"use strict"

var gulp   = require('gulp');
var insert = require('gulp-insert');
var rename = require('gulp-rename');
var elmx   = require('elmx');
var exec   = require('child_process').exec;
var mkdirp = require('mkdirp');

var src = './src'

gulp.task('default', ['watch']);

gulp.task('elmx', function() {
  return gulp.src(src + '/**/*.elmx')
    .pipe(insert.transform(elmx))
    .pipe(rename({extname: '.elm'}))
    .pipe(gulp.dest(src));
});

gulp.task('build', ['elmx'], function(cb) {
  mkdirp.sync('dist');
  var cmd = "elm-make src/Main.elm --output dist/elm.js";
  exec(cmd, function (error, stdout, stderr) {
    process.stdout.write(stdout);
    process.stderr.write(stderr);
    cb(error);
  });
});

gulp.task('watch', ['build'], function() {
  return gulp.watch(src + '/**/*.elmx', ['build']);
});
