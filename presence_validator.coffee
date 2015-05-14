class @PresenceValidator
  
  constructor: (@field, @condition) ->
    
  run: (doc) ->
    return unless doc?
    
    if @condition
      doc.error( @field, "#{@field} is missing" ) unless doc[@field]?
    else
      doc.error( @field, "#{@field} is present" ) if doc[@field]?
  