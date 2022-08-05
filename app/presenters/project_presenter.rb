class ProjectPresenter < BasePresenter
  def project_developers
    @project_developers = @project.users.where(role: "developer")
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

  def link_to_add_user_to_project user_id
		views.link_to("Add", views.add_user_project_path(user_id: user_id), method: :patch)
	end

  def link_to_delete_user_from_project user_id
		views.link_to("Delete", views.remove_user_project_path(user_id:user_id), method: :patch)
	end

end
