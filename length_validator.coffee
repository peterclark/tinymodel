class @LengthValidator
  
  constructor: (@field, @condition) ->
    
  run: (doc) ->
    return unless doc?
    
    l = if doc[@field] then doc[@field].length else 0
    
    if @condition.min
      if l < @condition.min
        doc.error( @field, "length of #{@field} must be at least #{@condition.min}" ) 
    else if @condition.max
      if l > @condition.max
        doc.error( @field, "length of #{@field} must be no more than #{@condition.max}" )
    else if @condition.in
      [min, middle..., max] = @condition.in
      if (l < min) or (l > max)
        doc.error( @field, "length of #{@field} must be between #{min} and #{max}" )
    else if @condition.is
      unless l == @condition.is
        doc.error( @field, "length of #{@field} must be exactly #{@condition.is}")
    else
      doc.error( @field, "please pass one of the following to the length validator: min, max, in, is")
  