Package.describe({
  name: 'peterclark:tinymodel',
  version: '0.0.1',
  summary: 'Easy to use models',
  git: 'https://github.com/peterclark/tinymodel',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use(['underscore', 'coffeescript'], ['server'])
  api.addFiles('tinymodel.coffee', ['server']);
});

Package.onTest(function(api) {
  api.use(['tinytest', 'peterclark:tinymodel', 'coffeescript', 'underscore'], ['server']);
  api.addFiles('tinymodel-tests.coffee', ['server']);
});
