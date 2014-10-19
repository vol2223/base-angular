gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
ngmin      = require 'gulp-ngmin'
uglify     = require 'gulp-uglify'
init       = require 'gulp-rimraf'
typescript = require 'gulp-tsc'
plumber    = require 'gulp-plumber'
sass       = require 'gulp-ruby-sass'
jade       = require 'gulp-jade'
plugins    = require('gulp-load-plugins')(camelize: true)
isWatching = false

gulp.task 'bower', ->
  bower = require('bower')
  bower.commands.install().on 'end', (installed) ->
    gulp.src [
      'bower_components/bootstrap/dist/css/bootstrap.min.css'
      'bower_components/angular/angular.min.js'
    ]
    .pipe gulp.dest './build/'

gulp.task 'jade', ->
  gulp.src "src/jade/**/*.jade"
    .pipe jade()
    .pipe gulp.dest 'build/www/html/'

gulp.task 'init', ->
  gulp.src 'build/'
  .pipe init()

gulp.task "browserify", ["tsCompile", "bower", "sassCompile", "jade"], ->
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
    'src/jade/**/*.jade'
    'src/sass/**/*.scss'
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
