gulp       = require('gulp')
coffee     = require('gulp-coffee')
ngmin      = require('gulp-ngmin')
uglify     = require('gulp-uglify')
init       = require('gulp-rimraf')
bower      = require('bower')
typescript = require('gulp-tsc')
plumber    = require 'gulp-plumber'
plugins    = require('gulp-load-plugins')(camelize: true)
isWatching = false

gulp.task 'bower', ->
  bower.commands.install().on 'end', (installed) ->
    gulp.src [
      'bower_components/bootstrap/dist/css/bootstrap.min.css'
      'bower_components/angular/angular.min.js'
    ]
    .pipe gulp.dest './build/'

gulp.task 'js', ->
  gulp.src 'app.coffee'
    .pipe coffee()
    .pipe ngmin()
    .pipe uglify()
    .pipe gulp.dest 'build/'

gulp.task 'init', ->
  gulp.src 'build/'
  .pipe init()

gulp.task "browserify", ["compile"], ->
  browserify = require("browserify")
  source = require("vinyl-source-stream")
  browserify
    basedir: "./build/www/js/"
    entries: ["./bootstrap.js"]
  .bundle()
  .pipe source "app.js"
  .pipe gulp.dest "build/www/js/"

gulp.task "compile", ->
  notify    = require 'gulp-notify'
  gulp.src "src/ts/**/*.ts"
    .pipe plumber errorHandler: notify.onError('<%= error.message %>')
    .pipe if isWatching then plugins.plumber() else plugins.util.noop()
    .pipe plugins.tsc
      module: "commonjs"
      noImplicitAny: true
      target: "ES5"
  .pipe gulp.dest("build/www/js")

gulp.task 'watch', ->
  gulp.watch [
    'src/ts/**/*.ts'
  ], -> gulp.start 'browserify'

gulp.task 'default', ['init'], ->
  gulp.start 'browserify', 'js', 'bower'
