Spry
===================

Experiments in wrapping the iOS SDK in a more Ruby-esque manner.

Samples
------------

Easily create a UITableViewController that leverages
NSFetchedResultsController to fetch data:

```ruby
class ArtistsController < Spry::EntityTableViewController
  entity    "Artist"
  sortBy    :name

  def layoutCell(cell, artist)
    cell.textLabel.text = artist.name
  end

  def selected(artist)
    puts "You selected #{artist.name}"
  end
end
```

Declarative entity specification:

```ruby
class Artist < Spry::Entity
  field :name,      :type => String
  field :imageUrl,  :type => String
  field :updatedAt, :type => Time
end
```

NOTE: Migrations are not handled, so wipe the DB if you change it.
