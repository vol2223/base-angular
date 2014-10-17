import angular = require('angular');
import serviceModule = require('./serviceModule');
import example = require('../example');

var m = angular.module('module.controller', [
    serviceModule.name
  ])
  .service('example', example)

export = m;
