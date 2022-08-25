require 'rails_helper'

RSpec.describe "Bugs", type: :request do
  let(:manager) { FactoryBot.create :user, role: 0 }
  let(:developer) { FactoryBot.create :user, role: 1 }
  let(:qa) { FactoryBot.create :user, role: 2 }
  let(:project1) { FactoryBot.create(:project, creator_id: manager.id ) }
  let(:user_project1) { FactoryBot.create(:users_project, user_id: manager.id, project_id: project1.id) }
  let(:user_project2) { FactoryBot.create(:users_project, user_id: developer.id, project_id: project1.id) }
  let(:bug1) { FactoryBot.create(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id ) }



  describe 'GET /show'  do
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
  end

  describe 'POST /create' do
    let(:bug_params) { attributes_for(:bug, project_id: project1.id, posted_by_id: qa.id, assigned_to_id: developer.id ) }

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
        expect(response). to redirect_to(project_path(project1.id))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new bug' do
        sign_in developer
        expect do
          post project_bugs_path(project1.id), params: { bug: bug_params }
        end.to change(Bug, :count).by(0)
      end

      it "renders a successful response " do
        sign_in developer
        post project_bugs_path(project1.id), params: { bug: bug_params }
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested bug' do
      qa2 = FactoryBot.create :user, role: 2
      project2 = FactoryBot.create(:project, creator_id: manager.id )
      bug2 = FactoryBot.create(:bug, project_id: project2.id, posted_by_id: qa2.id, assigned_to_id: developer.id )
      sign_in qa2
      expect do
        delete project_bug_path(project2.id, bug2.id)
      end.to change(Bug, :count).by(-1)
    end

    it 'fails to destroy the bug' do
      developer2 = FactoryBot.create :user, role: 1
      project2 = FactoryBot.create(:project, creator_id: manager.id )
      bug2 = FactoryBot.create(:bug, project_id: project2.id, posted_by_id: qa.id, assigned_to_id: developer2.id )
      sign_in developer2
      expect do
        delete project_bug_path(project2.id, bug2.id)
      end.to change(Bug, :count).by(0)
    end
  end
end
