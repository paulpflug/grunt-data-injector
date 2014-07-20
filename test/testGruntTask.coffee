chai = require "chai"
chai.should()

dataInjector = require "../src/dataInjector"
lib = require "../src/lib/dataInjector-lib"
file = "filename"
filecontent = """
(function() {
  var stuff = "test";
});
"""
mockupfiles = {}
mockupfiles[file] = filecontent
gruntfiles = [{src:[file],dest:file}]
class gruntMock 
  _mockupfiles = undefined
  _results = ""
  _json = ""
  results: () -> return _results
  options: () -> return _options
  _options = {}
  constructor: (files,mockupfiles,json) ->
    @files = files
    _json = json
    _mockupfiles = mockupfiles
    @mockupfiles = mockupfiles
  registerMultiTask: (str1,str2,cb) ->
    @task = cb
  log:
    write: (str) ->
    ok: (str) ->
  fail:
    warn: (str) ->
      _failwarn = str
  file:
    readJSON: () ->
      return JSON.parse(_json)
    exists: () ->
      return true
    read: (file) ->
      return _mockupfiles[file]
    write: (str1,str2) ->
      _results = str2
    copy: (str1,str2) ->
      _copydest = str2
describe "Grunt task", ->
  it "should work with the mockup", () ->
    grunt = new gruntMock(gruntfiles,mockupfiles)
    dataInjector(grunt)
    grunt.task.should.be.a("function")
  it "should produce the right results", () ->
    json = '{"key":"value"}'
    grunt = new gruntMock(gruntfiles,mockupfiles,json)
    dataInjector(grunt)
    grunt.task.should.be.a("function")
    grunt.task.call(grunt)
    options = lib(new gruntMock).getOptions()
    uninserted = filecontent.split("\n")
    formatted = options.formatter(JSON.parse(json),"\n",file).split("\n")
    inserted = grunt.results().split("\n")
    inserted[0].should.equal(uninserted[0])
    inserted[1].should.equal(formatted[1])
    inserted[2].should.equal(formatted[2])
    inserted[3].should.equal(formatted[3])
    inserted[4].should.equal(uninserted[1])
    inserted[5].should.equal(uninserted[2])