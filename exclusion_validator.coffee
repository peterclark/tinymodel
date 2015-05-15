class @ExclusionValidator
  
  constructor: (@field, @condition) ->
    
  run: (doc) ->
    return unless doc?
    
    if @condition.in and @condition.in instanceof Array
      if doc[@field] in @condition.in
        doc.error( @field, "#{doc[@field]} is reserved" )
    else
      doc.error( @field, "Please pass an Array to the in: parameter of the exclusion validator" )
  