gulp = require 'gulp'
browserify = require 'browserify'
gutil = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'
transform = require 'vinyl-transform'
uglify = require 'gulp-uglify'
jade = require 'gulp-jade'
watch = require 'gulp-watch'
watchify = require 'watchify'
del = require 'del'
concat = require 'gulp-concat'
less = require 'gulp-less'
path = require 'path'
gulpLiveScript = require 'gulp-livescript'
merge = require 'merge-stream'
streamqueue = require 'streamqueue'
source = require 'vinyl-source-stream'
fs = require 'fs'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
changed = require 'gulp-changed'
insert = require 'gulp-insert'
replace = require 'gulp-replace'
livereload = require 'gulp-livereload'
connect = require 'gulp-connect'

root = './dist/'

gulp.task 'ls', ->
  b = watchify(browserify("./src/app.ls", watchify.args))
  b.transform('liveify')
  b.bundle()
    .on('error', notify.onError("Error compiling livescript! \n <%= error.message %>"))
    .pipe(source('app.js'))
    .pipe(gulp.dest(root))
    .pipe(connect.reload())
    .pipe(notify(message: "Livescript compiled!", on-last: true))

gulp.task 'templates', ->
  jadeTask = jade {pretty: true}

  jadeTask.on('error', notify.onError("Error compiling jade! \n <%= error.message %>"))

  gulp.src('./src/**/*.jade')
    .pipe(jadeTask)
    .pipe(gulp.dest(root))
    .pipe(connect.reload())
    .pipe(notify(message: "Jade compiled!", on-last: true))

gulp.task 'stylesheet', ->
  gulp.src(['./src/app.less'], {base: './src/'})
    .pipe(plumber({errorHandler: notify.onError("Error compiling LESS \n <%= error.message %>")}))
    .pipe(less({paths: [/*path.join root, 'components'*/]}))
    .pipe(gulp.dest(path.join(root)))
    .pipe(connect.reload())
    .pipe(notify(message: "LESS compiled!", on-last: true))



gulp.task 'ls-watch', ->
  watch('src/**/*.ls', ['ls'], -> 
    gulp.start(['ls']))

gulp.task 'stylesheet-watch', ['stylesheet'], ->
  watch('src/**/*.less', -> 
    gulp.start('stylesheet'))

gulp.task 'templates-watch', ['templates'], ->
  watch('src/**/*.jade', -> 
    gulp.start('templates'))

gulp.task 'connect', ->
  connect.server({
    root: 'dist',
    livereload: true
  });

gulp.task 'default', [
  'ls'
  'ls-watch'
  'stylesheet'
  'stylesheet-watch'
  'templates'
  'templates-watch'
  'connect'
]