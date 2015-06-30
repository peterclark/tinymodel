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
  xmen_vehicle_names = (vehicle.name for vehicle in xmen.vehicles)
  vehicle_names = (vehicle.name for vehicle in [blackbird, aston])
  test.equal xmen_vehicle_names, vehicle_names

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

# clone

Tinytest.add 'clone - returns a clone of Mutant', (test) ->
  copy = Mutant.clone( storm )
  test.equal copy.name, storm.name
  test.equal copy.createdAt, storm.createdAt
  test.equal copy.updatedAt, storm.updatedAt

Tinytest.add 'clone - is not persisted', (test) ->
  copy = Mutant.clone( storm )
  test.isUndefined copy._id
  test.isFalse copy.persisted()

# remove

Tinytest.add 'remove - destroys the Mutant', (test) ->
  mutant = Mutant.insert( name: 'Magento', gender: 'male' )
  test.isTrue mutant.persisted()
  Mutant.remove( name: 'Magneto' )
  test.isUndefined Mutant.findOne( name: 'Magneto' )

# model.insert

Tinytest.add 'model.insert - inserts a Mutant', (test) ->
  colossus = new Mutant( name: 'Colossus', gender: 'male' )
  colossus.insert()
  mutant = Mutant.findOne( name: 'Colossus' )
  test.equal mutant.name, colossus.name
  test.matches mutant._id, /\S{17,}/
  test.instanceOf mutant.createdAt, Date
  test.instanceOf mutant.updatedAt, Date

Tinytest.add 'model.insert (invalid) - returns false', (test) ->
  mutant = new Mutant( name: '' )
  id = mutant.insert()
  test.isFalse id

Tinytest.add 'model.insert (invalid) - does not set timestamps', (test) ->
  mutant = new Mutant( name: '' )
  mutant.insert()
  test.isUndefined mutant.createdAt
  test.isUndefined mutant.updatedAt

Tinytest.add 'model.insert (persisted) - updates document', (test) ->
  mutant = new Mutant( name: 'NightCrawler', gender: 'male' )
  id = mutant.insert()
  mutant.name = 'Gambit'
  mutant.insert()
  test.equal Mutant.findOne( _id: id ).name, 'Gambit'

Tinytest.add 'model.insert (persisted, invalid) - fails', (test) ->
  mutant = new Mutant( name: 'Cyclops', gender: 'male' )
  id = mutant.insert()
  mutant.name = ''
  test.isFalse mutant.insert()
  test.equal Mutant.findOne( _id: id ).name, 'Cyclops'

# model.update

Tinytest.add 'model.update (not persisted) - return false', (test) ->
  gambit = new Mutant
  gambit.name = 'Gambit'
  test.isFalse gambit.update()

Tinytest.add 'model.update (persisted, invalid) - returns false', (test) ->
  rogue = Mutant.insert( name: 'Rogue', gender: 'female' )
  rogue.name = ''
  test.isFalse rogue.update()

Tinytest.add 'model.update (persisted, valid) - updates document', (test) ->
  ragnar = Mutant.insert( name: 'Ragnar', gender: 'male' )
  ragnar.name = 'Clown'
  ragnar.update()
  test.equal Mutant.findOne( _id: ragnar._id ).name, 'Clown'

# model.remove

Tinytest.add 'model.remove (persisted) - removes the document', (test) ->
  spiderman = Mutant.insert( name: 'Spiderman', gender: 'male' )
  result = spiderman.remove()
  test.isUndefined Mutant.findOne( _id: spiderman._id )
  test.equal result, 1

Tinytest.add 'model.remove (not persisted) - returns false', (test) ->
  mutant = new Mutant( name: 'Robert' )
  test.isFalse mutant.remove()

# model.persisted

Tinytest.add 'persisted - returns true', (test) ->
  mutant = Mutant.findOne()
  test.isTrue mutant.persisted()

Tinytest.add 'persisted (new) - returns false', (test) ->
  mutant = new Mutant( name: 'Alexander' )
  test.isFalse mutant.persisted()

# model.isValid

Tinytest.add 'isValid (valid) - returns true', (test) ->
  mutant = new Mutant( name: 'Tobias', gender: 'male' )
  test.isTrue mutant.isValid()

Tinytest.add 'isValid (invalid) - returns false', (test) ->
  mutant = new Mutant( name: 'Z' )
  test.isFalse mutant.isValid()

# model.attributes

Tinytest.add 'attributes - returns attributes', (test) ->
  mutant = Mutant.findOne( name: 'Wolverine' )
  test.equal mutant.attributes().name, 'Wolverine'
  test.equal mutant.attributes().gender, 'male'

# model.hasErrors

Tinytest.add 'hasErrors (invalid) - returns true', (test) ->
  mutant = new Mutant
  mutant.isValid()
  test.isTrue mutant.hasErrors()

Tinytest.add 'hasErrors (valid) - returns false', (test) ->
  mutant = new Mutant( name: 'George', gender: 'male' )
  test.isFalse mutant.hasErrors()

# model.errorMessages

Tinytest.add 'errorMessages (invalid) - returns error', (test) ->
  mutant = new Mutant
  mutant.isValid()
  test.equal mutant.errorMessages(), 'name is missing, length of name must be between 5 and 50, gender is invalid'

Tinytest.add 'errorMessages (valid) - returns empty string', (test) ->
  mutant = new Mutant( name: 'Gregory', gender: 'female' )
  mutant.isValid()
  test.equal mutant.errorMessages(), ''
