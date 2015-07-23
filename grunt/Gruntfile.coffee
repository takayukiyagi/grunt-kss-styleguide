module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.task.loadNpmTasks 'assemble'

  config =

    path:
      source: 'src'
      publish: '../htdocs'
      source_kss: 'src/styleguide'
      publish_kss: '../htdocs/styleguide'

    #
    # html
    #
    assemble:
      options:
        layout    : 'default.hbs'
        layoutdir : '<%= path.source %>/assemble/_layouts'
        partials  : '<%= path.source %>/assemble/_partials/**/*.hbs'
        assets    : '<%= path.publish %>/css'
      dist:
        files: [
          expand : true
          cwd    : '<%= path.source %>/assemble'
          src    : ['**/*.hbs', '!**/_layouts/*.hbs', '!**/_partials/*.hbs']
          dest   : '<%= path.publish %>'
        ]

    #
    # styles
    #
    sass:
      options:
        outputStyle: 'expanded'
        sourceMap : true
      dist:
        files: [
          expand: true
          cwd   : '<%= path.source %>/sass'
          src   : '**/*.scss'
          dest  : '<%= path.publish %>/css'
          ext   : '.css'
        ]

    #
    # less
    #
    less:
      options:
        compass: false
        yuicompress: false
        optimization: null
      source:
        expand: true
        cwd: '<%= path.source_kss %>/public'
        src: '*.less'
        dest: '<%= path.publish_kss %>/public'
        ext: '.css'

    #
    # styleguide
    #
    kss:
      options:
        css: '/css/style.css'
        template: '<%= path.source_kss %>'
      dist:
        files:
          '<%= path.publish_kss %>': ['<%= path.source %>/sass']

    #
    # watch
    #
    watch:
      options:
        spawn: false
        livereload: true
      assemble:
        files: ['<%= path.source %>/assemble/**/*.hbs']
        tasks: ['newer:assemble', 'notify:build']
      sass:
        files: ['<%= path.source %>/sass/**/*.scss']
        tasks: ['sass', 'kss', 'less', 'notify:build']
      kss_tpl:
        files: [
          '<%= path.source %>/**/*.less'
          '<%= path.source_kss %>/*.html'
        ]
        tasks: ['newer:assemble', 'less', 'notify:build']
      gruntfile:
        files: ['Gruntfile.coffee']

    #
    # notify
    #
    notify:
      build:
        options:
          title: 'ビルド完了'
          message: 'タスクが正常終了しました。'
      watch:
        options:
          title: '監視開始'
          message: 'ローカルサーバーを起動しました: http://localhost:3000/'

    #
    # local server
    #
    browserSync:
      dev:
        bsFiles:
          src: [
            '<%= path.publish %>/**/*.html'
            '<%= path.publish %>/css/*.css'
          ]
        options:
          watchTask: true
          open: false
          server:
            baseDir: '<%= path.publish %>'

    #
    # open
    #
    open:
      dev:
        path: 'http://' + (require('my-ip')(null, false)) + ':3000/index.html'


  #
  # grunt tasks
  #
  grunt.initConfig(config)
  grunt.registerTask 'default', []
  grunt.registerTask 'listen', [
    'sass'
    'kss'
    'less'
    'assemble'
    'browserSync'
    'notify:watch'
    'open'
    'watch'
  ]

