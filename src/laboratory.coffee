Experiment = require "./experiment"
{getSeedFromTime} = require './util'

class Laboratory
  constructor: (@store) ->
    @experiments = {}

  seedFromTime: (time) ->
    @seedFunction = -> getSeedFromTime time
    experiment.seedFunction = @seedFunction for name, experiment of @experiments

  addExperiment: (name) ->
    experiment = new Experiment(name, @store)
    experiment.seedFunction = @seedFunction if @seedFunction
    @experiments[name] = experiment
    experiment

  get: (name) ->
    throw new Error "Invalid Experiment Name" unless name?
    @experiments[name]

  run: (name) ->
    @get(name)?.run()

module.exports = Laboratory