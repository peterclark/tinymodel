TinyModel
=========

Simple models for Meteor

## Usage

1. Define a class that extents from TinyModel
2. Define the constructor as in the example below.
3. Add validation, class and instance methods.

```coffee
class @Mutant extends TinyModel
  # Tell the model what collection to use.
  @collection: new Meteor.Collection('mutants')
  
  # set passed in params as instance variables
  constructor: (params) ->
    for key,value of params
      @[key] = value
  
  # add validations
  validate: ->
    unless @name
      @error('name', 'Mutant name is required')
      
  # add class methods
  @evil: ->
    @all( leader: 'Magneto' )
    
  @good: ->
    @all( leader: 'Professor Xavier' )
    
  # add instance methods
  
  fly: ->
    if @canFly
      console.log 'Flying...'
      @isFlying = true
    else
      console.log 'Unable to fly.'
  
```

## Inserting

```coffee
  storm = new Mutant
  storm.name = 'Storm'
  storm.canFly = true
  storm.insert()
```

or

```coffee
  Mutant.insert( name: 'Storm', canFly: true )
```

## Finding

```coffee
  mutant = Mutant.findOne( name: 'Storm' )
  # => <Mutant name: 'Storm'...>
  mutants = Mutant.find( canFly: true )
  # => <Cursor>
  mutants = Mutant.all( canFly: true )
  # => [<Mutant>, <Mutant>, ...]
```

## Updating

```coffee
  storm.canFly = false
  storm.update()
```

## Removing

```coffee
  storm.remove()
```
or

```coffee
  Mutant.remove( name: 'Storm' )
```

## Counting

```coffee
  Mutant.count()
  # => 2
  Mutatn.count( canFly: true )
  # => 1
```

## Persisted

```coffee
  magneto = new Mutant
  magneto.name = 'Magneto'
  magneto.persisted()
  # => false
  magneto.insert()
  magneto.persisted()
  # => true
```

## Validate

```coffee
  cyclops = new Mutant
  cyclops.validate()
  # => 1
  cyclops.hasErrors()
  # => true
  cyclops.errors
  # => [ { name: 'Mutant name is required' }]
  cyclops.isValid()
  # => false
  cyclops.errorMessages()
  # => 'Mutant name is required'
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

    