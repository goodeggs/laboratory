Laboratory = require '../src/laboratory'
Experiment = require '../src/experiment'
MemoryStore = require '../src/memory_store'
{getSeedFromTime} = require '../src/util'


describe 'Custom Seeding', ->


  describe 'time based seeding', ->
    [
      {time: '2015-04-01 00:00:00', expected: 0.00}
      {time: '2015-04-01 00:30:00', expected: 0.50}
      {time: '2015-04-01 00:59:59', expected: 0.9997222222222223}
      {time: '2088-12-31 18:00:00', expected: 0}
    ].forEach ({time, expected}) ->
      it "converts #{time} to #{expected}", ->
        expect(getSeedFromTime new Date time).toBe expected


  describe 'on experiments', ->
    {experiment} = {}

    beforeEach ->
      experiment = new Experiment('foo')
      experiment.variant 'a', 50, 'A'
      experiment.variant 'b', 50, 'B'

    it 'returns the right variant for 0', ->
      experiment.seedFunction = -> 0
      expect(experiment.run().value).toBe 'A'

    it 'returns the right variant for 1', ->
      experiment.seedFunction = -> 1
      expect(experiment.run().value).toBe 'B'

    it 'returns the right variant for .50', ->
      experiment.seedFunction = -> .50
      expect(experiment.run().value).toBe 'B'


  describe 'on laboratories', ->
    it 'passes through the seed function when set before adding the experiment', ->
      laboratory = new Laboratory()
      laboratory.seedFromTime new Date '2015-04-01 11:00:00'
      experiment = laboratory.addExperiment 'bar'
      experiment.variant 'a', 50, 'A'
      experiment.variant 'b', 50, 'B'

      expect(laboratory.run('bar').value).toBe 'A'

    it 'passes through the seed function when set after adding the experiment', ->
      laboratory = new Laboratory()
      experiment = laboratory.addExperiment 'bar'
      experiment.variant 'a', 50, 'A'
      experiment.variant 'b', 50, 'B'
      laboratory.seedFromTime new Date '2015-04-01 11:00:00'

      expect(laboratory.run('bar').value).toBe 'A'
