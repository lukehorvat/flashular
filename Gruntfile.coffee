module.exports = (grunt) ->

  # Load required installed tasks.
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"

  # Configure tasks.
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    clean: [ "bin" ]
    coffeelint:
      files: [ "src/**/*.coffee" ]
      options:
        max_line_length:
          level: "ignore"
    coffee:
      compile:
        options:
          bare: true
        expand: true
        cwd: "src"
        src: [ "**/*.coffee" ]
        dest: "bin"
        ext: ".js"
    delta:
      options:
        livereload: true
      cwd: "src"
      files: [ "**/*.coffee" ]
      tasks: [ "coffeelint", "coffee" ]

  # Register build task.
  grunt.registerTask "build", [ "clean", "coffeelint", "coffee" ]

  # Register watch task. This task does a build before watching.
  grunt.renameTask "watch", "delta"
  grunt.registerTask "watch", [ "build", "delta" ]

  # Register default task.
  grunt.registerTask "default", [ "build" ]
