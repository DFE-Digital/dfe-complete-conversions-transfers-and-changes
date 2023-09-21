# Event logging

Users and the DfE need a log of events that happen to the main entities in the
service. To meet this need we have the `Event` model.

Events offer a simple interface to create a user facing log of events in the
application that can then be surfaced in the UI.

An Event is linked to a user, who triggered the event and optionally another
object that is associated to the event.

Right now we consider all events that are not associated to another object
'system' events.

Events can be triggered anywhere in the application so that we can explicitly
capture what is valuable.

## Creating new events

To create a new system event:

```ruby
Event.log(grouping: :system, user: user, message: "A description of the event")
```

To create a new project event you also supply the project object as `with`:

```ruby
Event.log(grouping: :project, with: project, user: user, message: "A description
of the project events")
```

## Fetching events

As events are nothing more than ActiveRecord models, you can fetch them however
you like, for example:

All system events:

`Events.system`

All the events for a project:

```ruby
project = Project.find(<id>)
events = project.events
```
