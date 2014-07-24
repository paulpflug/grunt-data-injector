lib = require "./lib/dataInjector-lib"

module.exports = (grunt) ->
  grunt.registerMultiTask "dataInjector", "injects data in source code" , () ->
    lib = lib(grunt)
    options = lib.getOptions(this.options())
    self = this
    self.files.forEach (array) ->          
      array.src.forEach (file) ->
        if grunt.file.exists(file) and grunt.file.exists(array.dest)
          grunt.log.ok "injecting "+file+ " in "+ array.dest
          raw = grunt.file.read file
          try
            data = options.parser raw
          catch e
            grunt.fail.warn("\n\nparsing failed\n"+e+"\n\n")
          if options.path
            data = lib.extractor(data,options.path,options.keepStructure)
          content = grunt.file.read array.dest
          returnType = if /\r\n/.test(content) then '\r\n' else '\n';
          formattedData = options.formatter data,returnType,file
          grunt.file.write array.dest, content.replace(new RegExp(options.inserter+"\s*"),options.inserter+formattedData)