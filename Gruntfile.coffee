"use strict"

module.exports = (grunt) ->

  # -------------------------------------------------------------------------- #
  # Path settings
  # -------------------------------------------------------------------------- #
  path =
    src: 'source'
    serv: 'server'
    dist: 'build'
    data: 'data'
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

    # Assemble (Static site generator)
    # ------------------------------------------------------------------------ #
    assemble:

      options:
        assets: path.src + '/assets'
        plugins: [
          'permalinks'
        ]
        partials: path.src + '/partials/**/*.html'
        layoutdir: path.src + '/layouts'
        layout: 'default.html'
        data: path.data + '/*.{json,yml,yaml}'

      server:
        options:
          assets: path.serv + '/assets'
        files: [
          cwd: path.src + '/'
          src: ['**/*.html', '!layouts/*.html', '!partials/*.html']
          dest: path.serv + '/'
          expand: true
          ext: ".html"
        ]

      build:
        options:
          assets: path.dist + '/assets'
        files: [
          cwd: path.src + '/'
          src: ['**/*.html', '!layouts/*.html', '!partials/*.html']
          dest: path.dist + '/'
          expand: true
          ext: ".html"
        ]

    # Autoprefixer (Adds browser prefixes to CSS)
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
          src: ['**/*.coffee', '!**/_*.coffee']
          dest: path.serv + '/' + path.assets.js
          ext: '.js'
        ]

      build:
        files: [
          expand: true
          cwd: path.src + '/' + path.assets.js
          src: ['**/*.coffee', '!**/_*.coffee']
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
          src: ['**/*.{sass,scss}']
          dest: path.serv + '/' + path.assets.css
          ext: '.css'
        ]

      build:
        files: [
          expand: true
          cwd: path.src + '/' + path.assets.css
          src: ['**/*.{sass,scss}']
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

      # Recompile HTML when an Assemble template is changed
      assemble:
        files: [path.src + '/' + '/**/*.html']
        tasks: ['assemble:server']
        options:
          livereload: true

      # Recompile JS when a Coffeescript file is changed
      coffee:
        files: [path.src + '/' + path.assets.js + '/**/*.coffee']
        tasks: ['coffeelint', 'clean:server:js', 'coffee:server']
        options:
          livereload: true

      # Trigger LiveReload when a CSS file is changed
      css:
        files: [path.serv + '/' + path.assets.css + '/**/*.css']
        options:
          livereload: true

      # Trigger LiveReload when an HTML file is changed
      html:
        files: [path.serv + '/**/*.html']
        options:
          livereload: true

      # Recompile CSS when a Sass file is changed
      sass:
        files: [path.src + '/' + path.assets.css + '/**/*.{sass,scss}']
        tasks: ['clean:server:css', 'sass:server']

  # -------------------------------------------------------------------------- #
  # Load all Grunt tasks
  # -------------------------------------------------------------------------- #
  grunt.loadNpmTasks 'assemble'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # -------------------------------------------------------------------------- #
  # Build tasks
  # -------------------------------------------------------------------------- #
  grunt.registerTask 'build', [
    'clean:build'
    'assemble:build'
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
    'assemble:server'
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
