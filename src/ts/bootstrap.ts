/// <reference path="../../DefinitelyTyped/angularjs/angular.d.ts" />
import angular = require('angular');
import example = require('./example');
angular.module('exampleProject', [])
  .service('example', example)

angular.bootstrap(document, ['exampleProject']);
