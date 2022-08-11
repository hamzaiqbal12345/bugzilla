class ProjectPresenter < BasePresenter
  def project_developers
    @project_developers = @project.users.where(role: 'developer')
  end

  def unassigned_developers
    @unassigned_developers = User.where(role: 'developer') - project_developers
  end

  def project_qa
    @project_qa = @project.users.where(role: 'qa')
  end

  def unassigned_qa
    @unassigned_qa = User.where(role: 'qa') - project_qa
  end

  def link_to_assign_user_to_project(user_id)
    views.link_to('Assign', views.add_user_project_path(user_id: user_id), method: :patch, remote: true , class: 'text-light')
  end

  def link_to_unassign_user_from_project(user_id)
    views.link_to('Unassign', views.remove_user_project_path(user_id: user_id), method: :patch, remote: true , class: 'text-light')
  end
end
