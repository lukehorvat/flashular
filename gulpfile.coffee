gulp = require "gulp"
coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"
ngAnnotate = require "gulp-ng-annotate"
rename = require "gulp-rename"
rimraf = require "rimraf"
size = require "gulp-size"
uglify = require "gulp-uglify"
watch = require "gulp-watch"
buildDir = "bin"
scripts = "src/**/*.coffee"

gulp.task "clean", (done) ->
  rimraf buildDir, done

gulp.task "build", ["clean"], ->
  gulp
    .src scripts
    .pipe coffeelint
      arrow_spacing: level: "error"
      max_line_length: level: "ignore"
    .pipe coffeelint.reporter()
    .pipe coffee()
    .pipe size showFiles: yes
    .pipe gulp.dest buildDir
    .pipe ngAnnotate()
    .pipe uglify mangle: no
    .pipe rename suffix: ".min"
    .pipe size showFiles: yes
    .pipe gulp.dest buildDir

gulp.task "watch", ["build"], ->
  watch glob: scripts, emitOnGlob: no, ["build"]

gulp.task "default", ->
  # The default task (i.e. "gulp" via the CLI).
  gulp.start "build"
