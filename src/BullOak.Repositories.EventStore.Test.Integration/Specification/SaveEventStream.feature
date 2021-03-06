﻿Feature: SaveEventsStream
	In order to persist using an event stream
	As a developer usint this new library
	I want to be able to save events in a stream

Scenario Outline: Save events in a new stream
	Given a new stream
	And <eventsCount> new events
	When I try to save the new events in the stream
	Then the save process should succeed
	 And there should be <eventsCount> events in the stream
Examples:
	| eventsCount |
	| 1           |
	| 30          |
	| 10000       |

Scenario: Save one event using interface
	Given a new stream
	And 1 new event
	When I try to save the new events in the stream through their interface
	Then the save process should succeed

Scenario: Save additional events in an existing stream
	Given an existing stream with 10 events
	And 10 new events
	When I try to save the new events in the stream
	Then the save process should succeed
	And there should be 20 events in the stream

Scenario: Concurrent write should fail for outdated session
	Given an existing stream with 10 events
	And session 'Session1' is open
	And session 'Session2' is open
	And 10 new events are added by 'Session1'
	And 10 new events are added by 'Session2'
	When I try to save 'Session1'
	And I try to save 'Session2'
	Then the save process should succeed for 'Session1'
	And the save process should fail for 'Session2' with ConcurrencyException
	And there should be 20 events in the stream

Scenario: Saving already saved session should throw meaningful usage advice exception
	Given an existing stream with 10 events
	And session 'Session1' is open
	And 10 new events are added by 'Session1'
	When I try to save 'Session1'
	And I try to save 'Session1'
	Then the save process should fail for 'Session1'
	And there should be 20 events in the stream

Scenario: Write after a hard deleted stream should fail
	Given a new stream
	And 3 new events
	And  I hard-delete the stream
	And 10 new events
	When I try to save the new events in the stream
	Then the save process should fail

Scenario: Write after a soft deleted stream should succeed
	Given a new stream
	And 3 new events
	And  I soft-delete the stream
	And 10 new events
	When I try to save the new events in the stream
	And I load my entity
	Then the load process should succeed
	And HighOrder property should be 9

Scenario Outline: Write after a soft delete by event for a stream should succeed
	Given an existing stream with <eventsCount1> events
	And I soft-delete-by-event the stream
	And <eventsCount2> new events
	When I try to save the new events in the stream
	And I load my entity
	Then the load process should succeed
	And HighOrder property should be <highOrder>
Examples:
	| eventsCount1 | eventsCount2 | highOrder |
	| 3            | 10           | 9         |
	| 10           | 3            | 2         |
	| 10           | 10000        | 9999      |
	| 10000        | 10           | 9         |

Scenario Outline: Write after a soft delete by event and new session opened should succeed
	Given a new stream
	And session 'session1' is open
	And <eventsCount1> new events are added by 'session1'
	When I try to save 'session1'
	And I soft-delete-by-event the stream
	And I open session 'session2'
	And I try to add <eventsCount2> new events to 'session2'
	And I try to save 'session2'
	And I load my entity
	Then the load process should succeed
	And HighOrder property should be <highOrder>
Examples:
	| eventsCount1 | eventsCount2 | highOrder |
	| 3            | 10           | 9         |
	| 10           | 3            | 2         |
	| 10           | 10000        | 9999      |
	| 10000        | 10           | 9         |

Scenario Outline: Write after a soft delete by custom event for a stream should succeed
	Given an existing stream with <eventsCount1> events
	And I soft-delete-by-custom-event the stream
	And <eventsCount2> new events
	When I try to save the new events in the stream
	And I load my entity
	Then the load process should succeed
	And HighOrder property should be <highOrder>
Examples:
	| eventsCount1 | eventsCount2 | highOrder |
	| 3            | 10           | 9         |
	| 10           | 3            | 2         |
	| 10           | 10000        | 9999      |
	| 10000        | 10           | 9         |

Scenario Outline: Write after a soft delete by custom event and new session opened should succeed
	Given a new stream
	And session 'session1' is open
	And <eventsCount1> new events are added by 'session1'
	When I try to save 'session1'
	And I soft-delete-by-custom-event the stream
	And I open session 'session2'
	And I try to add <eventsCount2> new events to 'session2'
	And I try to save 'session2'
	And I load my entity
	Then the load process should succeed
	And HighOrder property should be <highOrder>
Examples:
	| eventsCount1 | eventsCount2 | highOrder |
	| 3            | 10           | 9         |
	| 10           | 3            | 2         |
	| 10           | 10000        | 9999      |
	| 10000        | 10           | 9         |
