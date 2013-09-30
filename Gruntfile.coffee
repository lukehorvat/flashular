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

  grunt.loadNpmTasks "grunt-contrib-coffee"

  grunt.registerTask "default", ["coffee"]
