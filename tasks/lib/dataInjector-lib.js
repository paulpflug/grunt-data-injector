(function() {
  var extractor, extractorHelper, util, _;

  _ = require("lodash");

  util = require("util");

  extractor = function(data, path, keepStructure) {
    var keys;
    if (path) {
      keys = path.split(".");
      return extractorHelper(data, keys, keepStructure);
    }
  };

  extractorHelper = function(data, keys, keepStructure) {
    var dict, key, value;
    key = keys[0];
    if (keys.length > 1) {
      value = extractorHelper(data[key], keys.slice(1), keepStructure);
    } else {
      value = data[key];
    }
    if (keepStructure) {
      dict = {};
      dict[key] = value;
      return dict;
    } else {
      return value;
    }
  };

  module.exports = function(grunt) {
    var options;
    options = {
      options: {
        source: "json",
        target: "js",
        path: "",
        keepStructure: true
      },
      json: {
        options: {
          reader: grunt.file.readJSON
        }
      },
      js: {
        options: {
          inserter: "{",
          formatter: function(data, returnType, filename) {
            var formattedData, k, v;
            formattedData = [returnType + "  // content from " + filename + returnType];
            for (k in data) {
              v = data[k];
              formattedData.push("  var " + k + " = " + util.inspect(v, {
                depth: null
              }) + ";" + returnType);
            }
            formattedData.push("  // end of content from " + filename);
            return formattedData.join("");
          }
        }
      }
    };
    return {
      getOptions: function(setOptions) {
        if (!setOptions) {
          setOptions = {};
        }
        _.defaults(setOptions, options.options);
        _.defaults(setOptions, options[setOptions.source].options);
        _.defaults(setOptions, options[setOptions.target].options);
        return setOptions;
      },
      extractor: extractor
    };
  };

}).call(this);
