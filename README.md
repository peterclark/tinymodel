TinyModel [![Build Status](https://travis-ci.org/peterclark/tinymodel.svg?branch=master)](https://travis-ci.org/peterclark/tinymodel) [![Code Climate](https://codeclimate.com/github/peterclark/tinymodel/badges/gpa.svg)](https://codeclimate.com/github/peterclark/tinymodel)
=========

Tiny models for Meteor

## Usage

1. Define a class that extends from TinyModel.
2. Define the Meteor collection used by your class.
3. Define document fields
3. Add validations
4. Add relationships
5. Add custom class and instance methods

```coffee
# Step 1
class @Mutant extends TinyModel

  # Step 2
  @collection: new Meteor.Collection('mutants')

  # Step 3
  @field 'name', default: ''
  @field 'power', default: undefined
  @field 'gender', default: undefined

  # Step 4
  @validates 'name', presence: true, length: { in: [5..15] }
  @validates 'power', exclusion: { in: ['omnipotent'] }
  @validates 'gender', format: { with: /^(male|female)$/ }

  # Step 5
  @has a: 'team', of_class: 'Team'

  # Step 6
  @male: ->
    @all( gender: 'male' )

  @female: ->
    @all( gender: 'female' )

  attack: ->
    if @power
      "#{@power} attack!"
    else
      "no power specified"

class @Team extends TinyModel
  @collection: new Meteor.Collection('teams')

  @field 'name'

  @validates 'name', presence: true

  @has many: 'mutants', of_class: 'Mutant'
  @has a: 'leader', of_class: 'Mutant'
  @has an_embedded: 'headquarter', of_class: 'Location'
  @has many_embedded: 'vehicles', of_class: 'Vehicle'

  @evil: ->
    @findOne( leader: 'Magneto' )

  @good: ->
    @findOne( leader: 'Professor Xavier' )

```
## Example

```coffee
  xmen        = Team.insert( name: 'X-Men' )
  brotherhood = Team.insert( name: 'Brotherhood of Mutants' )
  wolverine   = Mutant.insert( name: 'Wolverine', gender: 'male', team_id: xmen._id )

  xmen.mutants()
  # => [<Mutant name: 'Wolverine'...>]

  wolverine.team()
  # => <Team name: 'X-Men'...>
```

## Inserting

```coffee
  storm = new Mutant
  storm.name = 'Storm'
  storm.gender = 'female'
  storm.power = 'weather control'
  storm.leader = 'Xavier'
  storm.insert()

  # or

  Mutant.insert( name: 'Storm', leader: 'Xavier', gender: 'female', power: 'weather control' )
```

## Finding

```coffee
  mutant = Mutant.findOne( name: 'Storm' )
  # => <Mutant name: 'Storm'...>
  mutants = Mutant.find( gender: 'female' )
  # => <Cursor>
  mutants = Mutant.all( gender: 'female' )
  # => [<Mutant>, <Mutant>, ...]
```

## Updating

```coffee
  storm.power = 'lightning'
  storm.update()
```

## Removing

```coffee
  storm.remove()

  # or

  Mutant.remove( name: 'Storm' )
```

## Counting

```coffee
  Mutant.count()
  # => 2
  Mutant.count( gender: 'female' )
  # => 1
```

## Persisted

```coffee
  magneto = new Mutant
  magneto.name = 'Magneto' #...
  magneto.persisted()
  # => false
  magneto.insert()
  magneto.persisted()
  # => true
```

## Validate

```coffee
  cyclops = new Mutant
  cyclops.isValid()
  # => false
  cyclops.hasErrors()
  # => true
  cyclops.errors
  # => [ { name: 'Mutant name is required' }...]
  cyclops.errorMessages()
  # => 'name is missing, length of name must be between 5 and 15...'
```

## Clone/Copy

```coffee
  storm = Mutant.findOne( name: 'Storm' )
  s2 = storm.copy()
  # => <Mutant _id: undefined, name: 'Storm'...>
  s2.insert()
  # => '3JtvMuwgjktwQoyBb'
  s2._id
  # => '3JtvMuwgjktwQoyBb'
```
