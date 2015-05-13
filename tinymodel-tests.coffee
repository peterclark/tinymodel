
class @Mutant extends TinyModel
  @collection: new Meteor.Collection('mutants')
  
  constructor: (params) ->
    for key,value of params
      @[key] = value
      
  validate: ->
    unless @name and @name.length > 3
      @error('name', 'Mutant name is too short')


# Database Setup
Mutant.remove( {} )

Mutant.insert name: 'Storm'
Mutant.insert name: 'Bo'
Mutant.insert name: 'Wolverine'
Mutant.insert name: 'Rogue'
Mutant.insert name: 'Magneto'

storm = Mutant.findOne name: 'Storm'

########################
# TinyModel.insert()
########################
Tinytest.add 'TinyModel.insert (valid) - sets parameters', (test) ->
  test.equal storm.name, 'Storm'
  
Tinytest.add 'TinyModel.insert (valid) - adds createdAt', (test) ->
  test.instanceOf storm.createdAt, Date
  
Tinytest.add 'TinyModel.insert (valid) - adds updatedAt', (test) ->
  test.instanceOf storm.updatedAt, Date
  
Tinytest.add 'TinyModel.insert (valid) - is valid', (test) ->
  test.isTrue storm.isValid()
  
Tinytest.add 'TinyModel.insert (valid) - assigns an id', (test) ->
  test.isNotNull storm._id
  test.notEqual storm._id, undefined
  test.length storm._id, 17
  
Tinytest.add 'TinyModel.insert (valid) - returns a Mutant', (test) ->
  test.instanceOf storm, Mutant
  
Tinytest.add 'TinyModel.insert (valid) - has no errors', (test) ->
  test.isFalse storm.hasErrors()
  
Tinytest.add 'TinyModel.insert (valid) - has no error messages', (test) ->
  test.length storm.errorMessages(), 0

Tinytest.add 'TinyModel.insert (invalid) - does not insert', (test) ->
  bo = Mutant.findOne name: 'Bo'
  test.isUndefined bo
  
Tinytest.add 'TinyModel.insert (invalid) - sets parameters', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.equal bo.name, 'Bo'
  
Tinytest.add 'TinyModel.insert (invalid) - is invalid', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.isFalse bo.isValid()
  
Tinytest.add 'TinyModel.insert (invalid) - does not assign an id', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.equal bo._id, undefined
  
Tinytest.add 'TinyModel.insert (invalid) - returns a Mutant', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.instanceOf bo, Mutant
  
Tinytest.add 'TinyModel.insert (invalid) - has errors', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.isTrue bo.hasErrors()
  
Tinytest.add 'TinyModel.insert (invalid) - has 1 error message', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.equal bo.errorMessages(), "Mutant name is too short"
  
###################
# TinyModel.find()
###################

Tinytest.add 'TinyModel.find - returns a cursor', (test) ->
  mutants = Mutant.find( {} )
  test.equal mutants._cursorDescription.collectionName, 'mutants'
  
Tinytest.add 'TinyModel.find (no query) - returns all', (test) ->
  mutants = Mutant.find( {} )
  test.equal mutants.fetch().length, 4
  
Tinytest.add 'TinyModel.find (with query) - returns subset', (test) ->
  mutants = Mutant.find( name: /ne/ )
  test.equal mutants.fetch().length, 2
  
Tinytest.add 'TinyModel.find - transforms to Mutant', (test) ->
  mutants = Mutant.find( {} )
  test.instanceOf mutants.fetch()[0], Mutant

######################
# TinyModel.all()
######################

Tinytest.add 'TinyModel.all - returns an array', (test) ->
  mutants = Mutant.all()
  test.instanceOf mutants, Array
  
Tinytest.add 'TinyModel.all - returns array of Mutants', (test) ->
  mutants = Mutant.all()
  test.instanceOf mutants[0], Mutant
  
Tinytest.add 'TinyModel.all (with query) - returns subset', (test) ->
  mutants = Mutant.all( name: /to/ )
  test.length mutants, 2

#####################
# TinyModel.findOne()
#####################
Tinytest.add 'TinyModel.findOne - returns a Mutant', (test) ->
  mutant = Mutant.findOne()
  test.instanceOf mutant, Mutant
  
Tinytest.add 'TinyModel.findOne (not found) - returns undefined', (test) ->
  mutant = Mutant.findOne( name: 'Larry' )
  test.isUndefined mutant

###################
# TinyModel.count()
###################
Tinytest.add 'TinyModel.count - returns count', (test) ->
  count = Mutant.count()
  test.equal count, 4
  
Tinytest.add 'TinyModel.count (with query) - returns count', (test) ->
  Mutant.remove({})
  Mutant.insert(name: 'Magneto')
  Mutant.insert(name: 'Storm')
  count = Mutant.count( name: /to/ )
  test.equal count, 2

######################
# TinyModel.toString()
######################
Tinytest.add 'TinyModel.toString - returns the collection name', (test) ->
  name = Mutant.toString()
  test.equal name, 'mutants'

###########################
# TinyModel.clone()
###########################
Tinytest.add 'TinyModel.clone( tm ) - returns a clone of Mutant', (test) ->
  copy = Mutant.clone( storm )
  test.equal copy.name, storm.name
  test.equal copy.createdAt, storm.createdAt
  test.equal copy.updatedAt, storm.updatedAt
  
Tinytest.add 'TinyModel.clone( tm ) - is not persisted', (test) ->
  copy = Mutant.clone( storm )
  test.isUndefined copy._id
  test.isFalse copy.persisted()

#####################
# TinyModel.remove()
#####################
Tinytest.add 'TinyModel.remove (with query) - destroys the Mutant', (test) ->
  Mutant.remove({})
  Mutant.insert( name: 'Magneto' )
  Mutant.remove( name: 'Magneto' )
  test.isUndefined Mutant.findOne( name: 'Magneto' )
  
Tinytest.add 'TinyModel.remove (with query) - returns count', (test) ->
  Mutant.remove({})
  Mutant.insert( name: 'Wolverine' )
  count = Mutant.remove( name: 'Wolverine' )
  test.equal count, 1
  
Tinytest.add 'TinyModel.remove( {} ) - destroys all Mutants', (test) ->
  count = Mutant.remove( {} )
  test.equal Mutant.all(), []
  
#####################
# model.insert()
#####################
  
Tinytest.add 'insert - inserts a Mutant', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  mutant.insert()
  test.equal Mutant.count(), 1
  
Tinytest.add 'insert - returns an id', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  id = mutant.insert()
  test.matches id, /\S{17,}/
  
Tinytest.add 'insert - sets timestamps', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  id = mutant.insert()
  test.instanceOf mutant.createdAt, Date
  test.instanceOf mutant.updatedAt, Date
  
Tinytest.add 'insert (invalid) - returns false', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Bo'
  id = mutant.insert()
  test.isFalse id
  
Tinytest.add 'insert (invalid) - does not set timestamps', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Bo'
  id = mutant.insert()
  test.isUndefined mutant.createdAt
  test.isUndefined mutant.updatedAt
  
Tinytest.add 'insert (persisted) - updates updatedAt', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  id = mutant.insert()
  oldUpdatedAt = mutant.updatedAt
  oldCreatedAt = mutant.createdAt
  mutant.name = 'Gambit'
  mutant.insert()
  test.isTrue mutant.updatedAt > oldUpdatedAt
  test.isTrue mutant.createdAt == oldCreatedAt

Tinytest.add 'insert (persisted) - updates document', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  id = mutant.insert()
  mutant.name = 'Gambit'
  mutant.insert()
  test.equal Mutant.findOne().name, 'Gambit'
  
Tinytest.add 'insert (persisted, invalid) - returns false', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  id = mutant.insert()
  mutant.name = 'Bo'
  id = mutant.insert()
  test.isFalse id

Tinytest.add 'insert (persisted, invalid) - does not persist', (test) ->
  Mutant.remove( {} )
  mutant = new Mutant
  mutant.name = 'Cyclops'
  id = mutant.insert()
  mutant.name = 'Bo'
  id = mutant.insert()
  test.notEqual Mutant.findOne().name, 'Bo'
  
#################
# model.update()
#################
  
Tinytest.add 'update (not persisted) - return false', (test) ->
  Mutant.remove( {} )
  gambit = new Mutant
  gambit.name = 'Gambit'
  test.isFalse gambit.update()
  
Tinytest.add 'update (peristed, invalid) - returns false', (test) ->
  Mutant.remove( {} )
  Mutant.insert( name: 'Gambit' )
  gambit = Mutant.findOne( name: 'Gambit' )
  gambit.name = ''
  test.isFalse gambit.update()
  
Tinytest.add 'update (persisted, valid) - updates updatedAt', (test) ->
  Mutant.remove( {} )
  Mutant.insert( name: 'Gambit' )
  gambit = Mutant.findOne( name: 'Gambit' )
  oldUpdatedAt = gambit.updatedAt
  gambit.name = 'Cyclops'
  gambit.update()
  test.isTrue gambit.updatedAt > oldUpdatedAt
  
Tinytest.add 'update (persisted, valid) - updates document', (test) ->
  Mutant.remove( {} )
  Mutant.insert( name: 'Gambit' )
  gambit = Mutant.findOne( name: 'Gambit' )
  gambit.name = 'Cyclops'
  gambit.update()
  test.equal Mutant.findOne().name, 'Cyclops'
  
#################
# model.remove()
#################

Tinytest.add 'remove (persisted) - removes the document', (test) ->
  Mutant.remove({})
  Mutant.insert( name: 'NightCrawler' )
  nc = Mutant.findOne()
  nc.remove()
  test.isUndefined Mutant.findOne()
  
Tinytest.add 'remove (persisted) - returns 1', (test) ->
  Mutant.remove({})
  Mutant.insert( name: 'NightCrawler' )
  nc = Mutant.findOne()
  result = nc.remove()
  test.equal result, 1
  
Tinytest.add 'remove (not persisted) - returns false', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'NightCrawler'
  test.isFalse mutant.remove()
  
#################
# model.persisted()
#################

Tinytest.add 'persisted - returns true', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'NightCrawler'
  mutant.insert()
  test.isTrue mutant.persisted()
  
Tinytest.add 'not persisted - returns false', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'NightCrawler'
  test.isFalse mutant.persisted()
  
#################
# model.isValid()
#################

Tinytest.add 'isValid (valid) - returns true', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'Rogue'
  test.isTrue mutant.isValid()
  
Tinytest.add 'isValid (invalid) - returns false', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'Ed'
  test.isFalse mutant.isValid()
  
###################
# model.attributes()
###################

Tinytest.add 'attributes - returns attributes', (test) ->
  Mutant.remove({})
  Mutant.insert( name: 'Rogue', color: 'green', gender: 'female' )
  rogue = Mutant.findOne()
  test.equal rogue.attributes().name, 'Rogue'
  test.equal rogue.attributes().color, 'green'
  test.equal rogue.attributes().gender, 'female'

###################
# model.hasErrors()
###################

Tinytest.add 'hasErrors (invalid) - returns true', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.isValid()
  test.isTrue mutant.hasErrors()
  
Tinytest.add 'hasErrors (valid) - returns false', (test) ->  
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'Xavier'
  test.isFalse mutant.hasErrors()
  
###################
# model.errorMessages()
###################

Tinytest.add 'errorMessages (invalid) - returns error', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.isValid()
  test.equal mutant.errorMessages(), 'Mutant name is too short'

Tinytest.add 'errorMessages (valid) - returns empty string', (test) ->
  Mutant.remove({})
  mutant = new Mutant
  mutant.name = 'Xavier'
  mutant.isValid()
  test.equal mutant.errorMessages(), ''


  
  
  
  
  
  
  
  
  
  
  
  