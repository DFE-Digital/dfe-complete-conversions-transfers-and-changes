class FlowController < ApplicationController
  def task_list
    flow = Flow.load_flow("conversion")

    @title = flow[:title]

    if flow[:description]
      @description = flow[:description]
    end

    @sections = flow[:sections]
  end

  def task
    flow = Flow.load_flow("conversion")

    task_slug = params[:slug]
    task = flow[:tasks][task_slug]
    @title = task["title"]
    @description = GovukMarkdown.render(task["description"])
    @definition = task
    @parts = task["parts"]
  end
end
