# Relationships

Tinytest.add 'has a - mutant has a team', (test) ->
  test.equal wolverine.team()._id, xmen._id

Tinytest.add 'has a - team has a leader', (test) ->
  test.equal xmen.leader()._id, xavier._id

Tinytest.add 'has many - team has many mutants', (test) ->
  xmen_mutant_ids = (mutant._id for mutant in xmen.mutants())
  mutant_ids = (mutant._id for mutant in [xavier, wolverine, storm])
  test.equal xmen_mutant_ids, mutant_ids

Tinytest.add 'has an_embedded - team has an embedded headquarter', (test) ->
  test.equal xmen.headquarter.name, xmansion.name

Tinytest.add 'has many_embedded - team has many embedded vehicles', (test) ->
  test.equal xmen.vehicles, [blackbird, aston]

# all

Tinytest.add 'all - returns an array', (test) ->
  mutants = Mutant.all()
  test.instanceOf mutants, Array

Tinytest.add 'all - returns array of Mutants', (test) ->
  mutants = Mutant.all()
  test.instanceOf mutants[0], Mutant

Tinytest.add 'all (with query) - returns subset', (test) ->
  mutants = Mutant.all( name: /to/ )
  test.length mutants, 1

# find

Tinytest.add 'find - returns a cursor', (test) ->
  mutants = Mutant.find( {} )
  test.equal mutants._cursorDescription.collectionName, 'mutants'

Tinytest.add 'find - returns all', (test) ->
  mutants = Mutant.find( {} )
  test.equal mutants.fetch().length, 3

Tinytest.add 'find - returns subset', (test) ->
  mutants = Mutant.find( name: /Xa/ )
  test.equal mutants.fetch().length, 1

Tinytest.add 'find - transforms to Mutant', (test) ->
  mutants = Mutant.find( {} )
  test.instanceOf mutants.fetch()[0], Mutant

# insert

Tinytest.add 'insert - sets name', (test) ->
  test.equal storm.name, 'Storm'

Tinytest.add 'insert - adds createdAt', (test) ->
  test.instanceOf storm.createdAt, Date

Tinytest.add 'insert - adds updatedAt', (test) ->
  test.instanceOf storm.updatedAt, Date

Tinytest.add 'insert - is valid', (test) ->
  test.isTrue storm.isValid()

Tinytest.add 'insert - returns a Mutant', (test) ->
  test.instanceOf storm, Mutant

Tinytest.add 'insert - assigns an id', (test) ->
  test.isNotNull storm._id
  test.notEqual storm._id, undefined
  test.length storm._id, 17

Tinytest.add 'insert - has no errors', (test) ->
  test.isFalse storm.hasErrors()

Tinytest.add 'insert - has no error messages', (test) ->
  test.length storm.errorMessages(), 0

Tinytest.add 'insert (invalid) - is invalid', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.isFalse bo.isValid()

Tinytest.add 'insert (invalid) - does not insert', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.isUndefined Mutant.findOne(name: 'Bo')

Tinytest.add 'insert (invalid) - does not assign an id', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.equal bo._id, undefined

Tinytest.add 'insert (invalid) - returns a Mutant', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.instanceOf bo, Mutant

Tinytest.add 'insert (invalid) - has errors', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.isTrue bo.hasErrors()

Tinytest.add 'insert (invalid) - has 1 error message', (test) ->
  bo = Mutant.insert name: 'Bo'
  test.equal bo.errorMessages(), "length of name must be between 5 and 50, gender is invalid"

# findOne

Tinytest.add 'findOne - returns a Mutant', (test) ->
  mutant = Mutant.findOne()
  test.instanceOf mutant, Mutant

Tinytest.add 'findOne (not found) - returns undefined', (test) ->
  mutant = Mutant.findOne( name: 'Larry' )
  test.isUndefined mutant

# count

Tinytest.add 'count - returns count', (test) ->
  count = Mutant.count()
  test.equal count, 3

Tinytest.add 'count (with query) - returns count', (test) ->
  count = Mutant.count( name: /to/ )
  test.equal count, 1

# toString

Tinytest.add 'toString - returns the collection name', (test) ->
  name = Mutant.toString()
  test.equal name, 'mutants'

# ###########################
# # TinyModel.clone()
# ###########################
# Tinytest.add 'TinyModel.clone( tm ) - returns a clone of Mutant', (test) ->
#   copy = Mutant.clone( storm )
#   test.equal copy.name, storm.name
#   test.equal copy.createdAt, storm.createdAt
#   test.equal copy.updatedAt, storm.updatedAt
#
# Tinytest.add 'TinyModel.clone( tm ) - is not persisted', (test) ->
#   copy = Mutant.clone( storm )
#   test.isUndefined copy._id
#   test.isFalse copy.persisted()
#
# #####################
# # TinyModel.remove()
# #####################
# Tinytest.add 'TinyModel.remove (with query) - destroys the Mutant', (test) ->
#   Mutant.remove({})
#   Mutant.insert( m_magneto )
#   Mutant.remove( name: 'Magneto' )
#   test.isUndefined Mutant.findOne( name: 'Magneto' )
#
# Tinytest.add 'TinyModel.remove (with query) - returns count', (test) ->
#   Mutant.remove({})
#   Mutant.insert( m_wolverine )
#   count = Mutant.remove( name: 'Wolverine' )
#   test.equal count, 1
#
# Tinytest.add 'TinyModel.remove( {} ) - destroys all Mutants', (test) ->
#   count = Mutant.remove( {} )
#   test.equal Mutant.all(), []
#
# #####################
# # model.insert()
# #####################
#
# Tinytest.add 'insert - inserts a Mutant', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_cyclops )
#   mutant.insert()
#   test.equal Mutant.count(), 1
#
# Tinytest.add 'insert - returns an id', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_cyclops )
#   id = mutant.insert()
#   test.matches id, /\S{17,}/
#
# Tinytest.add 'insert - sets timestamps', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_cyclops )
#   id = mutant.insert()
#   test.instanceOf mutant.createdAt, Date
#   test.instanceOf mutant.updatedAt, Date
#
# Tinytest.add 'insert (invalid) - returns false', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_bo )
#   id = mutant.insert()
#   test.isFalse id
#
# Tinytest.add 'insert (invalid) - does not set timestamps', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_bo )
#   id = mutant.insert()
#   test.isUndefined mutant.createdAt
#   test.isUndefined mutant.updatedAt
#
# Tinytest.add 'insert (persisted) - updates document', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_cyclops )
#   id = mutant.insert()
#   mutant.name = 'Gambit'
#   mutant.insert()
#   test.equal Mutant.findOne().name, 'Gambit'
#
# Tinytest.add 'insert (persisted, invalid) - returns false', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_cyclops )
#   id = mutant.insert()
#   mutant.name = 'Bo'
#   id = mutant.insert()
#   test.isFalse id
#
# Tinytest.add 'insert (persisted, invalid) - does not persist', (test) ->
#   Mutant.remove( {} )
#   mutant = new Mutant( m_cyclops )
#   id = mutant.insert()
#   mutant.name = 'Bo'
#   id = mutant.insert()
#   test.notEqual Mutant.findOne().name, 'Bo'
#
# #################
# # model.update()
# #################
#
# Tinytest.add 'update (not persisted) - return false', (test) ->
#   Mutant.remove( {} )
#   gambit = new Mutant
#   gambit.name = 'Gambit'
#   test.isFalse gambit.update()
#
# Tinytest.add 'update (peristed, invalid) - returns false', (test) ->
#   Mutant.remove( {} )
#   Mutant.insert( m_wolverine )
#   wolverine = Mutant.findOne( name: 'Wolverine' )
#   wolverine.name = ''
#   test.isFalse wolverine.update()
#
# Tinytest.add 'update (persisted, valid) - updates document', (test) ->
#   Mutant.remove( {} )
#   Mutant.insert( m_wolverine )
#   wolverine = Mutant.findOne( name: 'Wolverine' )
#   wolverine.name = 'Cyclops'
#   wolverine.update()
#   test.equal Mutant.findOne().name, 'Cyclops'
#
# #################
# # model.remove()
# #################
#
# Tinytest.add 'remove (persisted) - removes the document', (test) ->
#   Mutant.remove({})
#   Mutant.insert( m_wolverine )
#   nc = Mutant.findOne()
#   nc.remove()
#   test.isUndefined Mutant.findOne()
#
# Tinytest.add 'remove (persisted) - returns 1', (test) ->
#   Mutant.remove({})
#   Mutant.insert( m_magneto )
#   m = Mutant.findOne()
#   result = m.remove()
#   test.equal result, 1
#
# Tinytest.add 'remove (not persisted) - returns false', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant
#   mutant.name = 'NightCrawler'
#   test.isFalse mutant.remove()
#
# #################
# # model.persisted()
# #################
#
# Tinytest.add 'persisted - returns true', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant( m_storm )
#   mutant.insert()
#   test.isTrue mutant.persisted()
#
# Tinytest.add 'not persisted - returns false', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant
#   mutant.name = 'NightCrawler'
#   test.isFalse mutant.persisted()
#
# #################
# # model.isValid()
# #################
#
# Tinytest.add 'isValid (valid) - returns true', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant( m_rogue )
#   test.isTrue mutant.isValid()
#
# Tinytest.add 'isValid (invalid) - returns false', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant
#   mutant.name = 'Ed'
#   test.isFalse mutant.isValid()
#
# ###################
# # model.attributes()
# ###################
#
# Tinytest.add 'attributes - returns attributes', (test) ->
#   Mutant.remove({})
#   Mutant.insert( name: 'Rogue', leader: 'Xavier', gender: 'female' )
#   rogue = Mutant.findOne()
#   test.equal rogue.attributes().name, 'Rogue'
#   test.equal rogue.attributes().leader, 'Xavier'
#   test.equal rogue.attributes().gender, 'female'
#
# ###################
# # model.hasErrors()
# ###################
#
# Tinytest.add 'hasErrors (invalid) - returns true', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant
#   mutant.isValid()
#   test.isTrue mutant.hasErrors()
#
# Tinytest.add 'hasErrors (valid) - returns false', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant
#   mutant.name = 'Xavier'
#   test.isFalse mutant.hasErrors()
#
# ###################
# # model.errorMessages()
# ###################
#
# Tinytest.add 'errorMessages (invalid) - returns error', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant
#   mutant.isValid()
#   test.equal mutant.errorMessages(), 'name is missing, length of name must be between 5 and 50, gender is invalid'
#
# Tinytest.add 'errorMessages (valid) - returns empty string', (test) ->
#   Mutant.remove({})
#   mutant = new Mutant( m_magneto )
#   mutant.isValid()
#   test.equal mutant.errorMessages(), ''
