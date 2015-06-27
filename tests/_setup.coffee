# models

class @Mutant extends TinyModel
  @collection: new Meteor.Collection('mutants')

  @field 'name'
  @field 'power', default: 'strength'
  @field 'gender', default: 'unkown'

  @validates 'name', presence: true, length: { in: [5..50] }
  @validates 'power', exclusion: { in: ['omnipotent'] }
  @validates 'gender', format: { with: /^(male|female)$/ }

  @has a: 'team', of_class: 'Team'

class @Team extends TinyModel
  @collection: new Meteor.Collection('teams')

  @field 'name', presence: true

  @has a: 'leader', of_class: 'Mutant'
  @has many: 'mutants', of_class: 'Mutant'
  @has an_embedded: 'headquarter', of_class: 'Location'
  @has many_embedded: 'vehicles', of_class: 'Vehicle'

  @evil: ->
    @findOne( leader: 'Magneto' )

  @good: ->
    @findOne( leader: 'Professor Xavier' )

class @Location extends TinyModel

  @field 'name'
  @field 'longitude'
  @field 'latitude'

class @Vehicle extends TinyModel

  @field 'name'
  @field 'type'

Mutant.remove( {} )
Team.remove( {} )

@blackbird = new Vehicle( name: 'Blackbird', type: 'Airplane' )
@aston     = new Vehicle( name: 'Aston Martin DB9', type: 'Car' )
@xmansion  = new Location( name: 'X-Mansion', latitude: 41.3319204, longitude: -73.5662432 )

@xmen = Team.insert( name: 'X-Men', headquarter: xmansion, vehicles: [blackbird,aston] )

@xavier    = Mutant.insert( name: 'Professor Xavier', gender: 'male', power: 'telepathy', team_id: xmen._id )
@wolverine = Mutant.insert( name: 'Wolverine', gender: 'male', power: 'claws', team_id: xmen._id )
@storm     = Mutant.insert( name: 'Storm', gender: 'female', power: 'weather', team_id: xmen._id )

xmen.leader_id = xavier._id
xmen.update()
