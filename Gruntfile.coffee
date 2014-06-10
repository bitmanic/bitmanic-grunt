module.exports = (grunt) ->

  # Config settings
  $c =

    # Set source and build directories
    dir:
      source: 'source'
      build: 'build'

    # Set asset directories
    assets:
      css:  'assets/css'
      fonts: 'assets/fonts'
      img:  'assets/img'
      js:   'assets/js'

  # Project configuration.
  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    banner:
      "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - " +
      "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n" +
      "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" +
      "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.name %>;" +
      " Licensed <%= _.pluck(pkg.licenses, \"type\").join(\", \") %> */"


    # Clean (Empties build directories)
    clean:
      build:
        src: [
          $c.dir.build + '/' + $c.assets.css
          $c.dir.build + '/' + $c.assets.fonts
          $c.dir.build + '/' + $c.assets.js
          $c.dir.build + '/' + $c.assets.img
        ]

    # Coffeescript (Compile Coffeescript into JS)
    coffee:
      build:
        options:
          bare: true
        files: [
          expand: true
          cwd: $c.dir.source + '/' + $c.assets.js
          src: [
            '**/*.coffee'
            '**/*.js'
          ]
          dest: $c.dir.build + '/' + $c.assets.js
          ext: '.js'
        ]

    # Connect (Create a local server at http://localhost:4000)
    connect:
      server:
        options:
          base: './' + $c.dir.build + '/'
          port: '4000'
          host: '*'

    # HTML minification
    htmlmin:
      build:
        options:
          removeComments: true
          collapseWhitespace: true
        files: [
          expand: true              # Enable dynamic expansion.
          cwd: $c.dir.source + '/'  # Src matches are relative to this path.
          src: ['**/*.html']        # Actual pattern(s) to match.
          dest: $c.dir.build + '/'  # Destination path prefix.
          ext: '.html'              # Dest filepaths will have this extension.
        ]

    # JSHint
    jshint:
      files: ['gruntfile.js', 'source/**/*.js']
      options:
        globals:
          jQuery: true
          console: true
          module: true

    # Sass (Comple Sass files into CSS)
    sass:
      build:
        options:
          sourcemap: true
          style: 'compressed'
        files: [
          expand: true
          cwd: $c.dir.source + '/' + $c.assets.css
          src: [
            '**/*.sass'
            '**/*.scss'
          ]
          dest: $c.dir.build + '/' + $c.assets.css
          ext: '.css'
        ]

    # Uglify (Compress JS files)
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        compress:
          drop_console: true
        preserveComments: false
        sourceMap: true
      build:
        scripts:
          files: [
            expand: true
            cwd: $c.dir.source + '/' + $c.assets.js
            src: '/**/*.js'
            dest: $c.dir.build + '/' + $c.assets.js + '/scripts.min.js'
          ]

    # Watch (Things to do when the local server is runnning)
    watch:

      # Recompile CSS when a Sass file is changed
      css:
        files: [
          $c.dir.source + '/' + $c.assets.css + '/**/*.sass'
          $c.dir.source + '/' + $c.assets.css + '/**/*.scss'
        ]
        tasks: [
          'sass'
        ]

      # Minify HTML files
      html:
        files: [$c.dir.source + '/' + $c.assets.js + '/**/*.html']
        tasks: [
          'htmlmin'
        ]

      # Recompile JS when a Coffeescript file is changed
      js:
        files: [$c.dir.source + '/' + $c.assets.js + '/**/*.coffee']
        tasks: [
          'coffee'
          'jshint'
        ]

  # Load the desired plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'


  # Build tasks
  grunt.registerTask 'build', [
    'clean'
    'sass'
    'htmlmin'
    'coffee'
    'uglify'
  ]

  # Server tasks
  grunt.registerTask 'server', [
    'connect'
    'watch'
  ]

  # Default tasks
  grunt.registerTask 'default', [
    'build'
    'connect'
    'watch'
  ]

  return
