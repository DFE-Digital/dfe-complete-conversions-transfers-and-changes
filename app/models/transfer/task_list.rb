class Transfer::TaskList < ::BaseTaskList
  def self.layout
    [
      {
        identifier: :project_kick_off,
        tasks: []
      }
    ]
  end
end
