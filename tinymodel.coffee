app = @

class @TinyModel
  @collection: undefined
  errors: []

  constructor: (params={}) ->
    for field,value of params
      if @constructor.an_embedded? and @constructor.an_embedded[field]?
        klass = app[@constructor.an_embedded[field]]
        @[field] = new klass(value)
      else if @constructor.many_embedded? and @constructor.many_embedded[field]?
        klass = app[@constructor.many_embedded[field]]
        @[field] = (new klass(params) for params in value)
      else
        @[field] = value

  # Intialize the model.
  #
  # doc - the model attributes
  #
  # Examples
  #
  #   Car.new( color: 'blue' )
  #   # => <Car color: 'blue' ... >
  #
  # Returns a model
  @new: (doc={}) ->
    obj            = new @(doc)
    obj._id        = doc._id
    obj.createdAt  = doc.createdAt
    obj.updatedAt  = doc.updatedAt
    obj

  @field: (name, options={}) ->
    @::[name] = options.default

  @validates: (field, validations) ->
    # defining @validators class variable here instead of
    # above so that @validators is shared between instances
    # of the same subclass but not shared between all TinyModels
    @validators or= []
    for validator, condition of validations
      switch validator
        when 'presence'
          @validators.push new PresenceValidator(field, condition)
        when 'length'
          @validators.push new LengthValidator(field, condition)
        when 'exclusion'
          @validators.push new ExclusionValidator(field, condition)
        when 'format'
          @validators.push new FormatValidator(field, condition)
        when 'inclusion'
          @validators.push new InclusionValidator(field, condition)
        when 'numericality'
          @validators.push new NumericalityValidator(field, condition)

  @has: (options={}) ->
    # belongs_to relationship
    if options.a? and options.of_class?
      method_name     = options.a
      class_name      = options.of_class
      belongs_to_id   = "#{method_name}_id"
      @::[belongs_to_id] = undefined
      # add an instance method named method_name to the class that
      # has the @has declaration in it.
      @::[method_name] = do( class_name, belongs_to_id ) ->
        () -> app[class_name].findOne( _id: @[belongs_to_id] )
    # has_many relationship
    else if options.many? and options.of_class?
      method_name     = options.many
      class_name      = options.of_class
      has_many_id     = "#{@name.toLowerCase()}_id"
      @::[method_name] = do( class_name, has_many_id ) ->
        (selector={}) ->
          selector[has_many_id] = @_id
          app[class_name].all( selector )
    # an_embedded relationship
    else if options.an_embedded? and options.of_class?
      method_name = options.an_embedded
      class_name  = options.of_class
      @an_embedded or= []
      @an_embedded[method_name] = class_name
    # many_embedded relationship
    else if options.many_embedded? and options.of_class
      method_name = options.many_embedded
      class_name  = options.of_class
      @many_embedded or= []
      @many_embedded[method_name] = class_name

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

  # Modified from -
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
    if @persisted()
      @constructor.collection.remove( @_id )
    else
      false

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

  # Runs all validators on this model
  validate: ->
    @constructor.validators or= []
    val.run(@) for val in @constructor.validators
    @errors.length == 0

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

  isInvalid: ->
    @errors = []
    not @validate()

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
    attrs = _.omit( props, '_id', 'errors' )

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
