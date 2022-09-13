module GovukMarkdown
  def self.render(markdown)
    renderer = GovukMarkdown::Renderer.new(with_toc_data: true, link_attributes: {class: "govuk-link", target: "_blank"})
    Redcarpet::Markdown.new(renderer, tables: true, no_intra_emphasis: true).render(markdown).strip
  end
end
