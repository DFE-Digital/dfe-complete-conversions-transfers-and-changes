class FlowController < ApplicationController
  def task_list
    flow = Flow.load_flow("conversion")

    @title = flow[:title]

    if flow[:description]
      @description = flow[:description]
    end

    @sections = flow[:sections]
  end
end
