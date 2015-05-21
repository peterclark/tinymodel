Package.describe({
  name: 'peterclark:tinymodel',
  version: '0.0.4',
  summary: 'Tiny models for Meteor',
  git: 'https://github.com/peterclark/tinymodel',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use(['underscore', 'coffeescript', 'taskputty:underscore.string'], ['client', 'server'])
  api.addFiles(
    [ 'tinymodel.coffee', 'presence_validator.coffee', 'length_validator.coffee', 'exclusion_validator.coffee', 'format_validator.coffee' ], ['client', 'server']);
});

Package.onTest(function(api) {
  api.use(['tinytest', 'peterclark:tinymodel', 'coffeescript', 'underscore'], ['server']);
  api.addFiles(['tinymodel-tests.coffee', 'presence_validator.coffee', 'length_validator.coffee', 'exclusion_validator.coffee', 'format_validator.coffee'], ['server']);
});
