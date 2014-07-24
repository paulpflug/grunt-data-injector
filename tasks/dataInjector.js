(function() {
  var lib;

  lib = require("./lib/dataInjector-lib");

  module.exports = function(grunt) {
    return grunt.registerMultiTask("dataInjector", "injects data in source code", function() {
      var options, self;
      lib = lib(grunt);
      options = lib.getOptions(this.options());
      self = this;
      return self.files.forEach(function(array) {
        return array.src.forEach(function(file) {
          var content, data, e, formattedData, raw, returnType;
          if (grunt.file.exists(file) && grunt.file.exists(array.dest)) {
            grunt.log.ok("injecting " + file + " in " + array.dest);
            raw = grunt.file.read(file);
            try {
              data = options.parser(raw);
            } catch (_error) {
              e = _error;
              grunt.fail.warn("\n\nparsing failed\n" + e + "\n\n");
            }
            if (options.path) {
              data = lib.extractor(data, options.path, options.keepStructure);
            }
            content = grunt.file.read(array.dest);
            returnType = /\r\n/.test(content) ? '\r\n' : '\n';
            formattedData = options.formatter(data, returnType, file);
            return grunt.file.write(array.dest, content.replace(new RegExp(options.inserter + "\s*"), options.inserter + formattedData));
          }
        });
      });
    });
  };

}).call(this);
