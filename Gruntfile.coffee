"use strict"

module.exports = (grunt) ->

  # -------------------------------------------------------------------------- #
  # Path settings
  # -------------------------------------------------------------------------- #
  path =
    src: 'source'
    serv: 'server'
    dist: 'build'
    assets:
      css:    'assets/css'
      fonts:  'assets/fonts'
      img:    'assets/img'
      js:     'assets/js'

  # -------------------------------------------------------------------------- #
  # Project configuration
  # -------------------------------------------------------------------------- #
  grunt.initConfig

    # Read in the package.json file data
    # ------------------------------------------------------------------------ #
    pkg: grunt.file.readJSON('package.json')

    # Autoprefixer
    # ------------------------------------------------------------------------ #
    autoprefixer:
      build:
        options:
          map: true
          browsers: [
            'last 2 version'
            'ie 9'
          ]
        src: path.dist + '/' + path.assets.css

    # Clean (Empties build directories)
    # ------------------------------------------------------------------------ #
    clean:
      server:
        css:
          src: path.serv + '/' + path.assets.css
        js:
          src: path.serv + '/' + path.assets.js
      build:
        src: path.dist + '/'

    # Coffeescript (Compile Coffeescript into JS)
    # ------------------------------------------------------------------------ #
    coffee:

      options:
        bare: true
        sourceMap: true

      server:
        files: [
          expand: true
          cwd: path.src + '/' + path.assets.js
          src: ['**/*.coffee']
          dest: path.serv + '/' + path.assets.js
          ext: '.js'
        ]

      build:
        files: [
          expand: true
          cwd: path.src + '/' + path.assets.js
          src: ['**/*.coffee']
          dest: path.dist + '/' + path.assets.js
          ext: '.js'
        ]

    # Coffeelint
    # ------------------------------------------------------------------------ #
    coffeelint:
      app: [
        'Gruntfile.coffee'
        path.src + '/' + path.assets.js + '/*.coffee'
      ],
      options:
        no_trailing_whitespace:
          level: "error"



    # Connect (Create a local server at http://localhost:4000)
    # ------------------------------------------------------------------------ #
    connect:
      server:
        options:
          base: './' + path.serv + '/'
          port: '4000'
          host: '*'
          livereload: true

    # HTML minification
    # ------------------------------------------------------------------------ #
    htmlmin:
      build:
        options:
          removeComments: true
          collapseWhitespace: true
        files: [
          cwd: path.src + '/'
          src: '**/*.html'
          dest: path.dist + '/'
          expand: true
          ext: '.html'
        ]

    # Jade templating
    # ------------------------------------------------------------------------ #
    jade:
      server:
        options:
          debug: false
        files: [
          cwd: path.src + '/'
          src: [
            '**/*.jade'
            '!**/_*.jade'
            '!layouts/*.jade'
            '!partials/*.jade'
          ]
          dest: path.serv + '/'
          expand: true
          ext: ".html"
        ]
      build:
        options:
          debug: false
        files: [
          cwd: path.src + '/'
          src: "**/*.jade"
          dest: path.dist + '/'
          expand: true
          ext: ".html"
        ]

    # Sass (Comple Sass files into CSS)
    # ------------------------------------------------------------------------ #
    sass:

      options:
        sourcemap: true
        style: 'compressed'
        compass: true
        loadPath: ['bower_components']

      server:
        files: [
          expand: true
          cwd: path.src + '/' + path.assets.css
          src: ['**/*.sass', '**/*.scss']
          dest: path.serv + '/' + path.assets.css
          ext: '.css'
        ]

      build:
        files: [
          expand: true
          cwd: path.src + '/' + path.assets.css
          src: ['**/*.sass', '**/*.scss']
          dest: path.dist + '/' + path.assets.css
          ext: '.css'
        ]

    # Uglify (Compress JS files)
    # ------------------------------------------------------------------------ #
    uglify:
      options:
        compress:
          drop_console: true
        preserveComments: false
        sourceMap: true
      build:
        scripts:
          files: [
            expand: true
            cwd: path.src + '/' + path.assets.js
            src: '/**/*.js'
            dest: path.dist + '/' + path.assets.js + '/scripts.min.js'
          ]

    # Watch (Things to do when the local server is runnning)
    # ------------------------------------------------------------------------ #
    watch:

      # Recompile CSS when a Sass file is changed
      sass:
        files: [
          path.src + '/' + path.assets.css + '/**/*.sass'
          path.src + '/' + path.assets.css + '/**/*.scss'
        ]
        tasks: ['clean:server:css', 'sass:server']

      # Trigger LiveReload when a CSS file is changed
      css:
        files: [path.serv + '/' + path.assets.css + '/**/*.css']
        options:
          livereload: true

      # Recompile JS when a Coffeescript file is changed
      coffee:
        files: [path.src + '/' + path.assets.js + '/**/*.coffee']
        tasks: ['coffeelint', 'clean:server:js', 'coffee:server']
        options:
          livereload: true

      # Recompile HTML when a Jade file is changed
      jade:
        files: [path.src + '/' + '/**/*.jade']
        tasks: ['jade:server']
        options:
          livereload: true

      # Trigger LiveReload when an HTML file is changed
      html:
        files: [path.serv + '/**/*.html']
        options:
          livereload: true

  # -------------------------------------------------------------------------- #
  # Load all Grunt tasks
  # -------------------------------------------------------------------------- #
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # -------------------------------------------------------------------------- #
  # Build tasks
  # -------------------------------------------------------------------------- #
  grunt.registerTask 'build', [
    'clean:build'
    'jade:build'
    'htmlmin'
    'sass:build'
    'autoprefixer'
    'coffee:build'
    'uglify'
  ]

  # -------------------------------------------------------------------------- #
  # Server tasks
  # -------------------------------------------------------------------------- #
  grunt.registerTask 'server', [
    'clean:server'
    'jade:server'
    'sass:server'
    'coffeelint'
    'coffee:server'
    'connect'
    'watch'
  ]

  # -------------------------------------------------------------------------- #
  # Default tasks
  # -------------------------------------------------------------------------- #
  grunt.registerTask 'default', ['server']

  return
