class @NumericalityValidator
  
  constructor: (@field, @condition) ->
    
  run: (doc) ->
    return unless doc?
          
    number = doc[@field]
    
    if @condition.only_integer?
      unless /^[+-]?\d+$/.test "#{number}"
        doc.error(@field, "#{@field} must be an integer")
    
    if @condition.equal_to?
      unless number == @condition.equal_to
        doc.error(@field, "#{@field} must be exactly #{@condition.equal_to}")
    
    if @condition.greater_than?
      unless number > @condition.greater_than
        doc.error(@field, "#{@field} must be greater than #{@condition.greater_than}")
    
    if @condition.less_than?
      unless number < @condition.less_than
        doc.error(@field, "#{@field} must be less than #{@condition.less_than}")


  