Package.describe({
  name: 'peterclark:tinymodel',
  version: '0.1.1',
  summary: 'Tiny models for Meteor',
  git: 'https://github.com/peterclark/tinymodel',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use(
    [
      'underscore',
      'coffeescript',
      'taskputty:underscore.string@3.0.3_5'],
      ['client', 'server']);
  api.addFiles(
    [
      'tinymodel.coffee',
      'presence_validator.coffee',
      'length_validator.coffee',
      'exclusion_validator.coffee',
      'format_validator.coffee',
      'inclusion_validator.coffee',
      'numericality_validator.coffee'
    ], ['client', 'server']);
});

Package.onTest(function(api) {
  api.use(
    [
      'tinytest',
      'peterclark:tinymodel',
      'coffeescript',
      'underscore'
    ], ['server']);
  api.addFiles(
    [
      'tests/_setup.coffee',
      'tests/tests.coffee',
      'presence_validator.coffee',
      'length_validator.coffee',
      'exclusion_validator.coffee',
      'format_validator.coffee'
    ], ['server']);
});
