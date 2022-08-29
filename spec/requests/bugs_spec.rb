# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bugs', type: :request do
  let(:manager) { FactoryBot.create :user, role: 0 }
  let(:developer) { FactoryBot.create :user, role: 1 }
  let(:qa) { FactoryBot.create :user, role: 2 }
  let(:project1) { FactoryBot.create(:project, creator_id: manager.id) }
  let(:user_project1) { FactoryBot.create(:users_project, user_id: manager.id, project_id: project1.id) }
  let(:user_project2) { FactoryBot.create(:users_project, user_id: developer.id, project_id: project1.id) }
  let(:bug1) { FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id) }

  describe 'GET /show' do
    it 'returns status code 200 for showing projects bug to manager' do
      sign_in manager
      get project_bug_path(project1.id, bug1.id)
      expect(response).to have_http_status(:success)
    end

    it 'returns status code 200 for showing projects bug to developer' do
      sign_in developer
      get project_bug_path(project1.id, bug1.id)
      expect(response).to have_http_status(:success)
    end

    it 'returns status code 200 for showing projects bug to qa' do
      sign_in qa
      get project_bug_path(project1.id, bug1.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      sign_in qa
      get edit_project_bug_path(project1.id, bug1.id)
      expect(response).to have_http_status(:success)
    end
    context 'authorization' do
      it 'access failure when no signed in user' do
        get edit_project_bug_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST /create' do
    let(:bug_params) { attributes_for(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id) }
    let(:bug_params_invalid) { attributes_for(:bug, title: '', status: '', bug_type: '', project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id) }

    context 'with valid parameters' do
      it 'creates a new bug' do
        sign_in qa
        expect do
          post project_bugs_path(project1.id), params: { bug: bug_params }
        end.to change(Bug, :count).by(1)
      end

      it 'redirects to the created Project where bug is created' do
        sign_in qa
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(response).to redirect_to(project_path(project1.id))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new bug' do
        sign_in qa
        expect do
          post project_bugs_path(project1.id), params: { bug: bug_params_invalid }
        end.to change(Bug, :count).by(0)
      end

      it 'redirects to the created Project where bug is not created' do
        sign_in qa
        post project_bugs_path(project1.id), params: { bug: bug_params_invalid }
        expect(response).to redirect_to(project_path(project1.id))
      end

      it 'renders a successful response' do
        sign_in qa
        post project_bugs_path(project1.id), params: { bug: bug_params_invalid }
        expect(flash[:notice]).not_to eq('bug created successfully')
      end
    end

    context 'authorization' do
      it 'access failure when no signed in user' do
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(response).to have_http_status(302)
      end
      it 'access failure when unauthorized user sign in' do
        sign_in developer
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'assign developer to bug' do
    it 'assigns the developer' do
      sign_in developer
      new_attributes = attributes_for(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id)
      patch project_bug_assign_path(project1.id, bug1.id), params: { bug: new_attributes }
      bug1.reload
      expect(flash[:notice]).to eq('dev assigned successfully')
    end

    it 'fails to assign the developer' do
      sign_in developer
      new_attributes = attributes_for(:bug, project_id: project1.id, posted_by_id: qa.id)
      allow(bug1).to receive(:save).and_return(false)
      allow(project1.bugs).to receive(:find_by).and_return(bug1)
      allow(Project).to receive(:find_by).and_return(project1)
      patch project_bug_assign_path(project1.id, bug1.id), params: { bug: new_attributes }
      expect(flash[:alert]).to eq('not assigned')
    end

    context 'authorization' do
      it 'access failure when no signed in user' do
        patch project_bug_assign_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
      it 'access failure when unauthorized user sign in' do
        sign_in qa
        patch project_bug_assign_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
    end

  end

  describe 'start working status developer to bug' do
    it 'start working developer' do
      sign_in developer
      new_attributes = attributes_for(:bug, status: 'started')
      bug2 = FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id)
      patch project_bug_start_working_path(project1.id, bug2.id), params: { bug: new_attributes }
      bug2.reload
      expect(flash[:notice]).to eq('started successfully')
    end
    it 'fails to change status to start working for the developer' do
      bug2 = FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id)
      sign_in developer
      new_attributes = attributes_for(:bug, status: 'started' )
      allow(bug2).to receive(:save).and_return(false)
      allow(project1.bugs).to receive(:find_by).and_return(bug2)
      allow(Project).to receive(:find_by).and_return(project1)
      patch project_bug_start_working_path(project1.id, bug2.id), params: { bug: new_attributes }
      expect(flash[:alert]).to eq('not started')
    end

    context 'authorization' do
      it 'access failure when no signed in user' do
        patch project_bug_start_working_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
      it 'access failure when unauthorized user sign in' do
        sign_in qa
        patch project_bug_start_working_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'work_done status developer to bug' do
    it 'work_done developer' do
      sign_in developer
      bug2 = FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id, status: 'started')
      new_attributes = attributes_for(:bug, status: (bug2.bug_type == 'feature' ? 'completed' : 'resolved'))
      patch project_bug_work_done_path(project1.id, bug2.id), params: { bug: new_attributes }
      bug2.reload
      expect(flash[:notice]).to eq('work done successfully')
    end
    it 'fails to change status to work_done for the developer' do
      sign_in developer
      bug2 = FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id, status: 'started' )
      new_attributes = attributes_for(:bug,  status: (bug2.bug_type == 'feature' ? 'completed' : 'resolved'))
      allow(bug2).to receive(:save).and_return(false)
      allow(project1.bugs).to receive(:find_by).and_return(bug2)
      allow(Project).to receive(:find_by).and_return(project1)
      patch project_bug_work_done_path(project1.id, bug2.id), params: { bug: new_attributes }
      expect(response).to redirect_to(project_bug_path(project1.id, bug2.id))
      expect(flash[:alert]).to eq('work done failed')
    end

    context 'authorization' do
      it 'access failure when no signed in user' do
        patch project_bug_work_done_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
      it 'access failure when unauthorized user sign in' do
        sign_in qa
        patch project_bug_work_done_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested bug' do
      qa2 = FactoryBot.create :user, role: 2
      project2 = FactoryBot.create(:project, creator_id: manager.id)
      bug2 = FactoryBot.create(:bug, project_id: project2.id, posted_by_id: qa2.id, assigned_to_id: developer.id)
      sign_in qa2
      expect do
        delete project_bug_path(project2.id, bug2.id)
      end.to change(Bug, :count).by(-1)
    end

    it 'fails to destroy the bug' do
      sign_in qa
      allow(bug1).to receive(:destroy).and_return(false)
      allow(project1.bugs).to receive(:find).and_return(bug1)
      allow(Project).to receive(:find_by).and_return(project1)
      delete project_bug_path(project1.id, bug1.id)
      expect(flash[:alert]).to eq('bug not destroyed')
    end

    context 'authorization' do
      it 'access failure when no signed in user' do
        delete project_bug_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
      it 'access failure when unauthorized user sign in' do
        sign_in developer
        delete project_bug_path(project1.id, bug1.id)
        expect(response).to have_http_status(302)
      end
    end
  end
end
