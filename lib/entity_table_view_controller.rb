module Spry
  class EntityTableViewController < UITableViewController
    attr_accessor :context

protected

    # Configures the batch size when fetching records to display.
    def self.batchSize(size=nil)
      if size
        @batchSize = size
      else
        @batchSize || 20
      end
    end

    # Sets the entity name this table view controller will show.
    # This field is required.
    def self.entity(entityName=nil)
      if entityName
        @entityName = entityName
      else
        @entityName
      end
    end

    # Gets/sets the sort field used.
    # TODO: allow descending
    def self.sortBy(field=nil)
      if field
        @sortField = field.to_s
      else
        @sortField
      end
    end

protected

    def viewDidLoad
      view.dataSource = self
      view.delegate   = self
    end

    def numberOfSectionsInTableView(tableView)
      fetchedResultsController.sections.count
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
      # TODO: allow override
      reuseIdentifier = "#{self.class.entity}Cell"

      cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:reuseIdentifier)
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
        cell
      end

      entity = fetchedResultsController.objectAtIndexPath(indexPath);
      layoutCell(cell, entity)

      cell
    end

    def tableView(tableView, numberOfRowsInSection:section)
      fetchedResultsController.sections[section].numberOfObjects
    end

    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      entity = fetchedResultsController.objectAtIndexPath(indexPath);

      selected(entity)
    end

    def fetchedResultsController
      @fetchedResultsController ||= begin
        request = NSFetchRequest.alloc.init
        request.entity = NSEntityDescription.entityForName(self.class.entity, inManagedObjectContext:context)
        request.fetchBatchSize = self.class.batchSize
        request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey(self.class.sortBy, ascending:true)]

        controller = NSFetchedResultsController.alloc.initWithFetchRequest(request,
                                                                           managedObjectContext:context,
                                                                           sectionNameKeyPath:nil,
                                                                           cacheName:nil)
        controller.delegate = self

        error = Pointer.new(:object)
        unless controller.performFetch(error)
          puts "Error fetching data"
          abort
        end

        controller
      end
    end

    # TODO: support more granular update mechanisms
    def controllerDidChangeContent(controller)
      tableView.reloadData()
    end
  end
end
