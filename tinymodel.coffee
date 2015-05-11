class @TinyModel
  @collection: undefined
  errors: []
  
  # class methods
  
  @new: (doc={}) ->
    obj             = new @(doc)
    obj._id         = doc._id
    obj.createdAt  = doc.createdAt
    obj.updatedAt  = doc.updatedAt
    obj
  
  @find: (selector={}) ->
    options = {}
    options.transform = (doc) => @new( doc )
    @collection.find( selector, options )
    
  # Public: Find all documents that match the selector and initialize.
  #
  # selector - selection criteria
  #
  # Examples
  #
  #   Car.all( color: 'blue' )
  #   # => [Car, Car, Car]
  #
  # Returns an array of objects    
  @all: (selector={}) ->
    @find( selector ).fetch()
      
  @findOne: (selector={}) ->
    doc = @collection.findOne( selector )
    @new( doc ) if doc
    
  @insert: (params={}) ->
    doc = new @( params )
    doc.updatedAt = doc.createdAt = new Date()
    return doc unless doc.isValid()
    doc._id = @collection.insert( doc )
    doc

  @remove: (selector) ->
    @collection.remove( selector )
        
  @count: (selector={}) ->
    @collection.find( selector ).count()
    
  @toString: ->
    @collection._name
    
  # https://coffeescript-cookbook.github.io/chapters/classes_and_objects/cloning
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
    
  # instance methods
  
  insert: ->
    if @persisted()
      @update()
    else
      return false unless @isValid()
      @updatedAt = @createdAt = new Date()
      @_id = @constructor.collection.insert( @attributes() )
      
  update: ->
    if @persisted()
      return false unless @isValid()
      @updatedAt = new Date()
      @constructor.collection.update( @_id, { $set: @attributes() } )
    else
      false
  
  remove: ->
    @constructor.collection.remove( @_id )
      
  persisted: ->
    @_id?
    
  validate: ->
    true
    
  isValid: ->
    @errors = []
    @validate()
    @errors.length == 0
    
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
    
    
    
    
    
    