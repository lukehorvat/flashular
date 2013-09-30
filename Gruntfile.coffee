module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    coffee:
      source:
        options:
          bare: true
        expand: true
        cwd: "src"
        src: [ "**/*.coffee" ]
        dest: "dist"
        ext: ".js"
    watch:
      options:
        livereload: true
      cwd: "src"
      files: [ "**/*.coffee" ]
      tasks: [ "coffee" ]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", [ "coffee", "watch" ]
