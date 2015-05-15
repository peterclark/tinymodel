class @FormatValidator
  
  constructor: (@field, @condition) ->
    
  run: (doc) ->
    return unless doc?
    
    if @condition.with and @condition.with instanceof RegExp
      unless @condition.with.test doc[@field]
        doc.error( @field, "#{@field} is invalid")
    else
      doc.error( @field, "Please pass a regex expression to the with property." )
  