"use strict"

module.exports = (grunt) ->

  # -------------------------------------------------------------------------- #
  # Project configuration
  # -------------------------------------------------------------------------- #
  grunt.initConfig

    # Path settings
    # ------------------------------------------------------------------------ #

    path:

      # Locations
      loc:
        dev:    'source'
        server: 'server'
        build:  'build'

      # Assets
      assets:
        base:   'assets'
        css:    'assets/css'
        fonts:  'assets/fonts'
        img:    'assets/img'
        js:     'assets/js'

      # Bower components
      bower:
        bootstrap: 'bower_components/bootstrap-sass-official/vendor/assets'
        jquery:    'bower_components/jquery/dist/'
        modernizr: 'bower_components/modernizr'

    # Read in the package.json file data
    # ------------------------------------------------------------------------ #
    pkg: grunt.file.readJSON('package.json')

    # Assemble (Static site generator)
    # ------------------------------------------------------------------------ #
    assemble:

      options:
        plugins: ['permalinks']
        partials: '<%= path.loc.dev %>/partials/**/*.html'
        layoutdir: '<%= path.loc.dev %>/layouts'
        layout: 'default.html'
        data: 'data/*.{json,yml,yaml}'
        now: Date.now()

      server:
        options:
          assets: '<%= path.loc.server %>/<%= path.assets.base %>'
        files: [
          cwd: '<%= path.loc.dev %>/'
          src: ['**/*.html', '!{layouts,partials}/*.html']
          dest: '<%= path.loc.server %>/'
          expand: true
          ext: ".html"
        ]

      build:
        options:
          assets: '<%= path.loc.build %>/<%= path.assets.base %>'
        files: [
          cwd: '<%= path.loc.dev %>/'
          src: ['**/*.html', '!{layouts,partials}/*.html']
          dest: '<%= path.loc.build %>/'
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
        src: '<%= path.loc.build %>/<%= path.assets.css %>'

    # Clean (Empties build directories)
    # ------------------------------------------------------------------------ #
    clean:
      server:
        css:
          src: '<%= path.loc.server %>/<%= path.assets.css %>'
        js:
          src: '<%= path.loc.server %>/<%= path.assets.js %>'
      build:
        src: '<%= path.loc.build %>/'

    # Coffeescript (Compile Coffeescript into JS)
    # ------------------------------------------------------------------------ #
    coffee:

      options:
        bare: true
        sourceMap: true

      server:
        files: [
          expand: true
          cwd: '<%= path.loc.dev %>/<%= path.assets.js %>'
          src: ['**/*.coffee']
          dest: '<%= path.loc.server %>/<%= path.assets.js %>'
          ext: '.js'
        ]

      build:
        files: [
          expand: true
          cwd: '<%= path.loc.dev %>/<%= path.assets.js %>'
          src: ['**/*.coffee']
          dest: '<%= path.loc.build %>/<%= path.assets.js %>'
          ext: '.js'
        ]

    # Coffeelint
    # ------------------------------------------------------------------------ #
    coffeelint:
      app: [
        'Gruntfile.coffee'
        '<%= path.loc.dev %>/<%= path.assets.js %>/*.coffee'
      ],
      options:
        no_trailing_whitespace:
          level: "error"

    # Connect (Create a local server at http://localhost:4000)
    # ------------------------------------------------------------------------ #
    connect:
      server:
        options:
          base: '<%= path.loc.server %>'
          port: '4000'
          host: '*'
          livereload: true

    # Copy (copy vendor files into the project)
    # ------------------------------------------------------------------------ #
    copy:

      server:
        files: [

          # jQuery
          {
            expand: true,
            flatten: true
            src: '<%= path.bower.jquery %>/jquery.min.js'
            dest: '<%= path.loc.server %>/<%= path.assets.js %>/vendor/'
          }

          # Modernizr
          {
            expand: true,
            flatten: true
            src: '<%= path.bower.modernizr %>/modernizr.js'
            dest: '<%= path.loc.server %>/<%= path.assets.js %>/vendor/'
          }

        ]

      build:
        files: [

          # jQuery
          {
            expand: true,
            flatten: true
            src: '<%= path.bower.jquery %>/jquery.min.js'
            dest: '<%= path.loc.build %>/<%= path.assets.js %>/vendor/'
          }

          # Modernizr
          {
            expand: true,
            flatten: true
            src: '<%= path.bower.modernizr %>/modernizr.js'
            dest: '<%= path.loc.build %>/<%= path.assets.js %>/vendor/'
          }

        ]

    # HTML minification
    # ------------------------------------------------------------------------ #
    htmlmin:
      build:
        options:
          removeComments: true
          collapseWhitespace: true
        files: [
          cwd: '<%= path.loc.dev %>/'
          src: '**/*.html'
          dest: '<%= path.loc.build %>/'
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
          cwd: '<%= path.loc.dev %>/<%= path.assets.css %>'
          src: ['**/*.{sass,scss}']
          dest: '<%= path.loc.server %>/<%= path.assets.css %>'
          ext: '.css'
        ]

      build:
        files: [
          expand: true
          cwd: '<%= path.loc.dev %>/<%= path.assets.css %>'
          src: ['**/*.{sass,scss}']
          dest: '<%= path.loc.build %>/<%= path.assets.css %>'
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
            cwd: '<%= path.loc.dev %>/<%= path.assets.js %>'
            src: '/**/*.js'
            dest: '<%= path.loc.build %>/<%= path.assets.js %>/scripts.min.js'
          ]

    # Watch (Things to do when the local server is runnning)
    # ------------------------------------------------------------------------ #
    watch:

      # Recompile HTML when an Assemble template is changed
      assemble:
        files: ['<%= path.loc.dev %>/' + '/**/*.html']
        tasks: ['assemble:server']
        options:
          livereload: true

      # Recompile JS when a Coffeescript file is changed
      coffee:
        files: ['<%= path.loc.dev %>/<%= path.assets.js %>/**/*.coffee']
        tasks: ['coffeelint', 'clean:server:js', 'coffee:server']
        options:
          livereload: true

      # Trigger LiveReload when a CSS file is changed
      css:
        files: ['<%= path.loc.server %>/<%= path.assets.css %>/**/*.css']
        options:
          livereload: true

      # Trigger LiveReload when an HTML file is changed
      html:
        files: ['<%= path.loc.server %>/**/*.html']
        options:
          livereload: true

      # Recompile CSS when a Sass file is changed
      sass:
        files: ['<%= path.loc.dev %>/<%= path.assets.css %>/**/*.{sass,scss}']
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
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # -------------------------------------------------------------------------- #
  # Build tasks
  # -------------------------------------------------------------------------- #
  grunt.registerTask 'build', [
    'clean:build'
    'copy:build'
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
    'copy:server'
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
