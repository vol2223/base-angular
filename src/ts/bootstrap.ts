/// <reference path="../../DefinitelyTyped/angularjs/angular.d.ts" />
import angular = require('angular');
import controllerModule = require('./modules/controllerModule');

angular.module('exampleProject', [
      controllerModule.name
  ])

angular.bootstrap(document, ['exampleProject']);
