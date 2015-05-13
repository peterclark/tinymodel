
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
# Insert a valid TinyModel
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

###########################
# Insert an invalid TinyModel
###########################

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
# Find TinyModels
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
# All TinyModels
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
# Find one TinyModel
#####################
Tinytest.add 'TinyModel.findOne - returns a Mutant', (test) ->
  mutant = Mutant.findOne()
  test.instanceOf mutant, Mutant
  
Tinytest.add 'TinyModel.findOne (not found) - returns undefined', (test) ->
  mutant = Mutant.findOne( name: 'Larry' )
  test.isUndefined mutant

###################
# Count TinyModels
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

###########
# toString
###########
Tinytest.add 'TinyModel.toString - returns the collection name', (test) ->
  name = Mutant.toString()
  test.equal name, 'mutants'

###########################
# Clone a TinyModel
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
# Remove a TinyModel
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
# Insert a TinyModel
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
  
Tinytest.add 'insert (persisted) - only updates updatedAt', (test) ->
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
  

  
  
  
  
  
  
  
  
  
  
  
  
  