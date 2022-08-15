# frozen_string_literal: true

module BugsHelper
  def create_bug_assign_btn(project, bug)
    if bug.assigned_to_id
      case bug.status
      when 'neew'
        link_to('Start Working', project_bug_start_working_path(bug.project, bug), method: :patch, remote: true, class: 'btn btn-outline-primary')
      when 'started'
        link_to(bug.bug_type == 'bug' ? 'resolved' : 'completed', project_bug_work_done_path(bug.project, bug), remote: true, method: :patch, class: 'btn btn-outline-primary')
      end
    else
      link_to 'assign', project_bug_assign_path(project, bug), method: :patch, remote: true, class: 'btn btn-outline-primary'
    end
  end
end
