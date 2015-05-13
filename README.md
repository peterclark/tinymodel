TinyModel
=========

Simple models for Meteor

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


    