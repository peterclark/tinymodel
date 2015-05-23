class @InclusionValidator
  
  constructor: (@field, @condition) ->
    
  run: (doc) ->
    return unless doc?
    
    if @condition.in and @condition.in instanceof Array
      if doc[@field] not in @condition.in
        doc.error( @field, "#{@field} should be one of #{@condition.in}" )
    else
      doc.error( @field, "Please pass an Array to the in: parameter of the inclusion validator" )
  