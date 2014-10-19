gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
ngmin      = require 'gulp-ngmin'
uglify     = require 'gulp-uglify'
init       = require 'gulp-rimraf'
typescript = require 'gulp-tsc'
plumber    = require 'gulp-plumber'
sass       = require 'gulp-ruby-sass'
plugins    = require('gulp-load-plugins')(camelize: true)
isWatching = false

gulp.task 'bower', ['js'], ->
  bower = require('bower')
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

gulp.task "browserify", ["tsCompile", "bower", "sassCompile"], ->
  browserify()

gulp.task "watchBrowserify", ["tsCompile", "sassCompile"], ->
  browserify()

gulp.task "tsCompile", ->
  tsCompile()

gulp.task "sassCompile", ->
  sassCompile()

gulp.task 'watch', ->
  gulp.watch [
    'src/ts/**/*.ts'
  ], -> gulp.start 'watchBrowserify'

gulp.task 'default', ['init'], ->
  gulp.start 'browserify'

browserify = ->
  browserify = require("browserify")
  source = require("vinyl-source-stream")
  browserify
    basedir: "./build/www/js/"
    entries: ["./bootstrap.js"]
  .bundle()
  .pipe source "app.js"
  .pipe gulp.dest "build/www/js/"

tsCompile = ->
  notify    = require 'gulp-notify'
  gulp.src "src/ts/**/*.ts"
    .pipe plumber errorHandler: notify.onError('<%= error.message %>')
    .pipe if isWatching then plugins.plumber() else plugins.util.noop()
    .pipe plugins.tsc
      module: "commonjs"
      noImplicitAny: true
      target: "ES5"
  .pipe gulp.dest("build/www/js")

sassCompile = ->
  gulp.src 'src/scss/**/*.scss'
    .pipe sass({style : 'expanded'})
    .pipe gulp.dest('build/www/css');
