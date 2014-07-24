# grunt-data-injector

"Grunt Task that injects data into source.",
  
A simple [Grunt][grunt] multitask that injects data into source code. e.g. JSON in js.
Useful when you need static data simultaneously in a markup template and source code. 


## Table of Contents

<!-- toc -->
* [Getting Started](#getting-started)
  * [Use it with grunt](#use-it-with-grunt)
* [Documentation](#documentation)
  * [Example](#example)
  * [Options](#options)
* [Extensions](#extensions)
* [Release History](#release-history)
* [License](#license)

<!-- toc stop -->
## Getting Started

### Use it with grunt

Install this grunt plugin next to your project's [grunt.js gruntfile][getting_started] with: `npm install grunt-data-injector`

Then add this line to your project's `grunt.js` gruntfile:

```javascript
grunt.loadNpmTasks('grunt-data-injector');
```

[grunt]: https://github.com/cowboy/grunt
[getting_started]: https://github.com/cowboy/grunt/blob/master/docs/getting_started.md

## Documentation
### Example
Assume you have the following file structure:
```
data\
  somefile.json
  subdir\
    anotherfile.json
js\
  somefile.js
  subdir\
    anotherfile.js
```
than this task
```coffee
dataInjector:
  options:
    # change options on global level
  compile:
    options:
      # change options on task level
    files: [
      expand: true,
      cwd: "data/",
      src: ["**/*.json"],
      ext: ".js",
      dest: "js/"   
    ]
```
would inject the data from the `.json` files into the corresponding `.js` files.

### Options
Here the available options with the corresponding defaults:
```coffee
# name of the reader - currently `json` or `yaml` available
source: "json"

# name of the formatter - currently only `js` available
target: "js"

# a dot-separated path to select data from the json prior injecting.
path: ""

# only in conjunction with path. Keeps the structure of the selected data if set.
keepStructure: true

# function which will take a filename and return a js object, used to read the data.
reader: grunt.file.readJSON

# string, after which the data will be injected.
inserter: "{"

# function which takes the data and returns a string ready for injection
formatter: (data,returnType,filename) ->
  formattedData = [returnType+"  // content from "+filename+returnType]
  for k,v of data
    formattedData.push "  var "+k+" = "+util.inspect(v,{depth:null})+";"+returnType
  formattedData.push "  // end of content from "+filename
  return formattedData.join("")
```
## Extensions

If you build your own reader or formatter, I would be happy to include them!

## Release History

 - *v0.0.2*: Added support for yaml
 - *v0.0.1*: First Release

## License
Copyright (c) 2014 Paul Pflugradt
Licensed under the MIT license.
