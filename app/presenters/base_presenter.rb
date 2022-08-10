class BasePresenter
  def initialize(project, template)
    @project = project
    @template = template
  end

  def views
    @template
  end
end
