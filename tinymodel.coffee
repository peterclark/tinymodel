class @TinyModel
  @collection: undefined
  errors: []
    
  # Intialize the model.
  #
  # doc - the model attributes
  #
  # Examples
  #
  #   Car.new( color: 'blue' )
  #   # => <Car color: 'blue' ... >
  #
  # Returns an array of models 
  @new: (doc={}) ->
    obj            = new @(doc)
    obj._id        = doc._id
    obj.createdAt  = doc.createdAt
    obj.updatedAt  = doc.updatedAt
    obj
    
  # Find all documents that match the selector.
  #
  # selector - selection criteria
  #
  # Examples
  #
  #   Car.find( color: 'red' )
  #   # => Cursor
  #
  # Returns a cursor. Once cursor is iterated, returns models.  
  @find: (selector={}) ->
    options = {}
    options.transform = (doc) => @new( doc )
    @collection.find( selector, options )
    
  # Find all documents that match the selector and initialize.
  #
  # selector - selection criteria
  #
  # Examples
  #
  #   Car.all( color: 'blue' )
  #   # => [Car, Car, Car]
  #
  # Returns an array of models    
  @all: (selector={}) ->
    @find( selector ).fetch()

  # Find first document that match the selector and initialize.
  #
  # selector - selection criteria
  #
  # Examples
  #
  #   Car.findOne( color: 'blue' )
  #   # => <Car color: 'blue'...>
  #
  # Returns one model       
  @findOne: (selector={}) ->
    doc = @collection.findOne( selector )
    @new( doc ) if doc

  # Inserts a document with given attributes
  #
  # params - attributes
  #
  # Examples
  #
  #   Car.insert( color: 'blue', spoiler: true )
  #   # => <Car _id: '123', color: 'blue', spoiler: true ...>
  #
  # Returns one model     
  @insert: (params={}) ->
    doc = new @( params )
    doc.updatedAt = doc.createdAt = new Date()
    return doc unless doc.isValid()
    doc._id = @collection.insert( doc )
    doc

  # Remove documents based on selector
  #
  # selector - selection criteria
  #
  # Examples
  #
  #   Car.remove( color: 'blue' )
  #   # => 1
  #
  #   Car.remove( {} )
  #   # => removes all documents
  #
  # Returns number of documents removed 
  @remove: (selector) ->
    @collection.remove( selector )
    
  # Find the number of documents in the collection
  #
  # selector - selection criteria
  #
  # Examples
  #
  #   Car.count( color: 'blue' )
  #   # => 2
  #
  #   Car.count()
  #   # => total count of all documents
  #
  # Returns a number         
  @count: (selector={}) ->
    @collection.find( selector ).count()

  # Get name of collection
  #
  # Examples
  #
  #   Car.toString()
  #   # => 'cars'
  #
  # Returns a string     
  @toString: ->
    @collection._name
    
  # Taken from - 
  # https://coffeescript-cookbook.github.io/chapters/classes_and_objects/cloning
  # 
  # Clone a model
  #
  # obj - the object to clone
  #
  # Examples
  #
  #   Car.clone( car )
  #   # => <Car color: 'blue'...>
  #
  # Returns an unsaved model
  @clone: (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj

    if obj instanceof Date
      return new Date( obj.getTime() ) 

    if obj instanceof RegExp
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags) 

    newInstance = new obj.constructor()

    for key of obj
      if key == '_id'
        newInstance['_id'] = undefined
      else 
        newInstance[key] = @clone( obj[key] )

    return @new( newInstance )
    
  # Insert this model.
  #
  # Examples
  #
  #   car = new Car
  #   car.color = 'blue'
  #   car.insert()
  #   # => '123abc'
  #
  # Returns the id of the newly created document or false if insert failed
  insert: ->
    if @persisted()
      @update()
    else
      return false unless @isValid()
      @updatedAt = @createdAt = new Date()
      @_id = @constructor.collection.insert( @attributes() )

  # Update this model.
  #
  # Examples
  #
  #   car = Car.findOne( color: 'blue' )
  #   car.color = 'red'
  #   car.update()
  #   # => 1
  #
  # Returns the # of documents updated or false if update failed      
  update: ->
    if @persisted()
      return false unless @isValid()
      @updatedAt = new Date()
      @constructor.collection.update( @_id, { $set: @attributes() } )
    else
      false

  # Removes this model.
  #
  # Examples
  #
  #   car = Car.findOne( color: 'blue' )
  #   car.remove()
  #   # => 1
  #
  # Returns the # of documents removed 
  remove: ->
    @constructor.collection.remove( @_id )

  # Check if this model is persisted (has an _id).
  #
  # Examples
  #
  #   car = Car.findOne( color: 'blue' )
  #   car.persisted()
  #   # => true
  #
  # Returns true if document has an id, false otherwise     
  persisted: ->
    @_id?

  # Validate the model
  #
  # Examples
  #
  #   car = new Car
  #   car.color = 'red'
  #   car.validate()
  #   # => true
  #
  # Returns true if validations pass. Override this in your subclasses.   
  validate: ->
    true
    
  # Check if this model is valid
  #
  # Examples
  #
  #   car = new Car
  #   car.color = 'red'
  #   car.isValid()
  #   # => true
  #
  # Returns true if model has no errors, false otherwise   
  isValid: ->
    @errors = []
    @validate()
    @errors.length == 0
    
  # Get the own properties of this model
  #
  # Examples
  #
  #   car = Car.findOne( color: 'blue' )
  #   car.attributes()
  #   # => { color: 'blue' }
  #
  # Returns an object with the models attributes   
  attributes: ->
    own   = Object.getOwnPropertyNames( @ )
    props = _.pick( @, own )
    attrs = _.omit( props, '_id' )
   
  error: (field, message) ->
    @errors ||= []
    e = {}
    e[field] = message
    @errors.push e
    
  hasErrors: ->
    @errors.length > 0
    
  errorMessages: ->
    msg = []
    for i in @errors
      for key, value of i
        msg.push value
    msg.join(', ')
    
  copy: (obj) ->
    @constructor.clone( @ )
    
    
    
    
    
    