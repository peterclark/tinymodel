TinyModel
=========

Simple models for Meteor

## Usage

1. Define a class that extends from TinyModel.
2. Define the Meteor collection used by your class.
2. Define the constructor as in the example below.
3. Add validation, class and instance methods.

```coffee
# Step 1
class @Mutant extends TinyModel
  # Step 2
  @collection: new Meteor.Collection('mutants')
  
  # Step 3
  constructor: (params={}) ->
    { @name, @power, @gender, @leader } = params
  
  # Step 4    
  @validates 'name', presence: true, length: { in: [5..15] }
      
  @evil: ->
    @all( leader: 'Magneto' )
    
  @good: ->
    @all( leader: 'Xavier' )
    
  attack: ->
    if @power
      "#{@power} attack!"
    else
      "no power specified"
  
```

## Inserting

```coffee
  storm = new Mutant
  storm.name = 'Storm'
  storm.leader = 'Xavier'
  storm.insert()

  # or
  
  Mutant.insert( name: 'Storm', leader: 'Xavier' )
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
  storm.power = 'weather control'
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
  Mutant.count( canFly: true )
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
  cyclops.isValid()
  # => false
  cyclops.hasErrors()
  # => true
  cyclops.errors
  # => [ { name: 'Mutant name is required' }]
  cyclops.errorMessages()
  # => 'name is missing, length of name must be between 5 and 15'
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

    