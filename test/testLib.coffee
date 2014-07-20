chai = require "chai"
chai.should()


class gruntMock
  file:
    readJSON: () ->


lib = require("../src/lib/dataInjector-lib")(new gruntMock)

options = lib.getOptions()

describe "Formatter for js", ->
  it "should work with simple objects", ->
    obj = {
      key:"value"
      key2: 2
      key3: true
    }
    result = options.formatter(obj,"\n","test")
    result.should.equal "\n  // content from test\n  var key = 'value';\n  var key2 = 2;\n  var key3 = true;\n  // end of content from test"
  it "should work with deeply nested objects", ->
    obj = {
      key:
        key:
          key:
            key:
              key:"value"
    }
    result = options.formatter(obj,"\n","test")
    result.should.equal "\n  // content from test\n  var key = { key: { key: { key: { key: 'value' } } } };\n  // end of content from test"

describe "Extractor", ->
  obj = {
      key1:
        key11:"value11"
        key12:"value12"
      key2: 
        key21:"value21"
        key22:"value22"
    }
  it "should work with keepStructure", ->
    result = lib.extractor(obj,"key1.key11",true)
    result.should.deep.equal({key1:{key11:"value11"}})
  it "should work without keepStructure", ->
    result = lib.extractor(obj,"key1.key11",false)
    result.should.equal("value11")