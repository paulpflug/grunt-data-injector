_ = require "lodash"
util = require "util"
YAML = require "js-yaml"
extractor = (data,path,keepStructure) ->
  if path
    keys = path.split(".")
    return extractorHelper(data,keys,keepStructure)
extractorHelper = (data,keys,keepStructure) ->
  key = keys[0]
  if keys.length > 1
    value = extractorHelper(data[key],keys.slice(1),keepStructure)
  else
    value = data[key]
  if keepStructure
    dict = {}
    dict[key] = value
    return dict
  else
    return value

module.exports = (grunt) ->
  options = {
    options:
      source: "json"
      target: "js"
      path: ""
      keepStructure: true
    json:
      options:
        parser: JSON.parse
    yaml:
      options:
        parser: YAML.load
    js:
      options:
        inserter: "{"
        formatter: (data,returnType,filename) ->
          formattedData = [returnType+"  // content from "+filename+returnType]
          for k,v of data
            formattedData.push "  var "+k+" = "+util.inspect(v,{depth:null})+";"+returnType
          formattedData.push "  // end of content from "+filename
          return formattedData.join("")
  }
  return {
    getOptions: (setOptions) ->
      setOptions = {} if not setOptions
      _.defaults(setOptions,options.options)
      _.defaults(setOptions, options[setOptions.source].options)
      _.defaults(setOptions, options[setOptions.target].options)
      return setOptions
    extractor: extractor
  }