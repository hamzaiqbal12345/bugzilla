# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bugs', type: :request do
  let(:manager) { create(:user, role: 0) }
  let(:developer) { create(:user, role: 1) }
  let(:qa) { create(:user, role: 2) }
  let(:project1) { create(:project, creator_id: manager.id) }
  let(:user_project1) { create(:users_project, user_id: manager.id, project_id: project1.id) }
  let(:user_project2) { create(:users_project, user_id: developer.id, project_id: project1.id) }
  let(:user_project3) { create(:users_project, user_id: qa.id, project_id: project1.id) }
  let(:bug1) { create(:bug, project_id: project1.id, posted_by_id: qa.id) }

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

    context 'with authorization' do
      it 'access failure when no signed in user' do
        get edit_project_bug_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /create' do
    let(:bug_params) { attributes_for(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id) }
    let(:bug_params_invalid) { attributes_for(:bug, title: nil, status: nil, bug_type: nil, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id) }

    context 'with valid parameters' do
      before do
        sign_in qa
      end

      it 'creates a new bug' do
        expect do
          post project_bugs_path(project1.id), params: { bug: bug_params }
        end.to change(Bug, :count).by(1)
      end

      it 'redirects to the created Project where bug is created' do
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(response).to redirect_to(project_path(project1.id))
      end
    end

    context 'with invalid parameters' do
      before do
        sign_in qa
      end

      it 'does not create a new bug' do
        expect do
          post project_bugs_path(project1.id), params: { bug: bug_params_invalid }
        end.to change(Bug, :count).by(0)
      end

      it 'redirects to the created Project where bug is not created' do
        post project_bugs_path(project1.id), params: { bug: bug_params_invalid }
        expect(response).to redirect_to(project_path(project1.id))
      end

      it 'renders a successful response' do
        post project_bugs_path(project1.id), params: { bug: bug_params_invalid }
        expect(flash[:notice]).not_to eq('bug created successfully')
      end
    end

    context 'with authorization' do
      it 'access failure when no signed in user' do
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(response).to have_http_status(:found)
      end

      it 'access failure when unauthorized user sign in' do
        sign_in developer
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'assign developer to bug' do
    context 'with assigning bug' do
      let(:new_attributes) { attributes_for(:bug, assigned_to_id: developer.id) }

      before do
        sign_in developer
      end

      it 'assigns the developer' do
        patch project_bug_assign_path(project1.id, bug1.id), params: { bug: new_attributes }
        expect(flash[:notice]).to eq('dev assigned successfully')
      end

      it 'fails to assign the developer' do
        allow(bug1).to receive(:save).and_return(false)
        allow(project1.bugs).to receive(:find_by).and_return(bug1)
        allow(Project).to receive(:find_by).and_return(project1)
        patch project_bug_assign_path(project1.id, bug1.id), params: { bug: bug1 }
        expect(flash[:alert]).to eq('not assigned')
      end
    end

    context 'with authorization' do
      it 'access failure when no signed in user' do
        patch project_bug_assign_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end

      it 'access failure when unauthorized user sign in' do
        sign_in qa
        patch project_bug_assign_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'start working status developer to bug' do
    context 'with start working status' do
      let(:bug2) { FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id) }
      let(:new_attributes) { attributes_for(:bug, status: 'started') }

      before do
        sign_in developer
      end

      it 'start working developer' do
        patch project_bug_start_working_path(project1.id, bug2.id), params: { bug: new_attributes }
        expect(flash[:notice]).to eq('started successfully')
      end

      it 'fails to change status to start working for the developer' do
        allow(bug2).to receive(:save).and_return(false)
        allow(project1.bugs).to receive(:find_by).and_return(bug2)
        allow(Project).to receive(:find_by).and_return(project1)
        patch project_bug_start_working_path(project1.id, bug2.id), params: { bug: new_attributes }
        expect(flash[:alert]).to eq('not started')
      end
    end

    context 'with authorization' do
      it 'access failure when no signed in user' do
        patch project_bug_start_working_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end

      it 'access failure when unauthorized user sign in' do
        sign_in qa
        patch project_bug_start_working_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'work_done status developer to bug' do
    context 'with work done status' do
      let(:bug2) { FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id, status: 'started') }
      let(:new_attributes) { attributes_for(:bug, status: (bug2.bug_type == 'feature' ? 'completed' : 'resolved')) }

      before do
        sign_in developer
      end

      it 'work_done developer' do
        patch project_bug_work_done_path(project1.id, bug2.id), params: { bug: new_attributes }
        expect(flash[:notice]).to eq('work done successfully')
      end

      it 'fails to change status to work_done for the developer' do
        allow(bug2).to receive(:save).and_return(false)
        allow(project1.bugs).to receive(:find_by).and_return(bug2)
        allow(Project).to receive(:find_by).and_return(project1)
        patch project_bug_work_done_path(project1.id, bug2.id), params: { bug: new_attributes }
        expect(flash[:alert]).to eq('work done failed')
      end
    end

    context 'with authorization' do
      it 'access failure when no signed in user' do
        patch project_bug_work_done_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end

      it 'access failure when unauthorized user sign in' do
        sign_in qa
        patch project_bug_work_done_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with delete bug' do
      before do
        sign_in qa
      end

      it 'destroys the requested bug' do
        bug2 = create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id)
        expect do
          delete project_bug_path(project1.id, bug2.id)
        end.to change(Bug, :count).by(-1)
      end

      it 'fails to destroy the bug' do
        allow(bug1).to receive(:destroy).and_return(false)
        allow(project1.bugs).to receive(:find).and_return(bug1)
        allow(Project).to receive(:find_by).and_return(project1)
        delete project_bug_path(project1.id, bug1.id)
        expect(flash[:alert]).to eq('bug not destroyed')
      end
    end

    context 'with authorization' do
      it 'access failure when no signed in user' do
        delete project_bug_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end

      it 'access failure when unauthorized user sign in' do
        sign_in developer
        delete project_bug_path(project1.id, bug1.id)
        expect(response).to have_http_status(:found)
      end
    end
  end
end
