gulp       = require('gulp')
coffee     = require('gulp-coffee')
ngmin      = require('gulp-ngmin')
uglify     = require('gulp-uglify')
init       = require('gulp-rimraf')
bower      = require('bower')
typescript = require('gulp-tsc')
plugins    = require('gulp-load-plugins')(camelize: true)
isWatching = false

gulp.task 'bower', ->
  bower.commands.install().on 'end', (installed) ->
    gulp.src(
      'bower_components/bootstrap/dist/css/bootstrap.min.css'
      'bower_components/angular/angular.min.js'
    ).pipe gulp.dest './build/'

gulp.task 'js', ->
  gulp.src 'app.coffee'
    .pipe coffee()
    .pipe ngmin()
    .pipe uglify()
    .pipe gulp.dest 'build/'

gulp.task 'static', ->
  gulp.src [
    'manifest.json'
    'newtab.html'
    'bower_components/bootstrap/dist/fonts/'
  ]
  .pipe gulp.dest 'build/'

gulp.task 'init', ->
  gulp.src 'build/'
  .pipe init()

#gulp.task "compile", ->
#  gulp.src "src/**/*.ts"
#    .pipe typescript out: 'unified.js'
#    .pipe gulp.dest "dest/"

gulp.task "compile", ->
  gulp.src "src/ts/**/*.ts"
    .pipe if isWatching then plugins.plumber() else plugins.util.noop()
    .pipe plugins.tsc
      module: "commonjs"
      noImplicitAny: true
      target: "ES5"
  .pipe gulp.dest("build/modules/")

gulp.task 'watch', ->
  gulp.watch [
    '*.coffee'
    '*.html'
  ], -> gulp.start 'js', 'static', 'compile'

gulp.task 'default', ['init'], ->
  gulp.start 'bower', 'js', 'static', 'compile'
