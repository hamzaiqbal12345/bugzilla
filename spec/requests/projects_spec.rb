# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:project2) { create(:project, creator_id: user1.id) }
  let(:project1) { create(:project, creator_id: user.id) }
  let(:user_project1) { create(:users_project, user_id: user.id, project_id: project1.id) }
  let(:project_params_valid) { attributes_for(:project, creator_id: user.id, title: Faker::Game.title) }
  let(:project_invalid_params) { attributes_for(:project, title: nil, description: nil) }

  before do
    sign_in user
  end

  describe 'GET /index'  do
    it 'returns status code 200 for getting all project' do
      get projects_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns the project with given id' do
      get project_path(project1.id)
      expect(assigns(:project)).to eql(project1)
    end

    it 'returns status code 200 for showing one project' do
      get project_path(project1.id)
      expect(response).to have_http_status(:success)
    end

    it 'renders a show template' do
      get project_path(project1.id)
      expect(response).to render_template(:show)
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        get project_path(project2.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_project_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template in response' do
      get new_project_path
      expect(response).to render_template(:new)
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        get project_path(project2.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      get edit_project_path(project1.id)
      expect(response).to have_http_status(:success)
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        get edit_project_path(project2.id)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Project' do
        expect do
          post projects_path, params: { project: project_params_valid }
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the created Project' do
        post projects_path, params: { project: project_params_valid }
        expect(response).to redirect_to(project_path(Project.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Post' do
        expect do
          post projects_path, params: { project: project_invalid_params }
        end.to change(Project, :count).by(0)
      end

      it 'renders a failure response ' do
        post projects_path, params: { project: project_invalid_params }
        expect(response).to render_template(:new)
      end
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        project_params = attributes_for(:project, creator_id: user1.id)
        post projects_path, params: { project: project_params }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested project' do
        patch project_path(project1.id), params: { project: project_params_valid }
        project1.reload
        expect(flash[:notice]).to eq('Project has been updated successfully')
      end

      it 'redirects to the project' do
        patch project_path(project1.id), params: { project: project_params_valid }
        project1.reload
        expect(response).to redirect_to(project_path(project1.id))
      end
    end

    context 'with invalid parameters' do
      it 'renders a successful response' do
        patch project_path(project1.id), params: { project: project_invalid_params }
        project1.reload
        expect(response).to render_template(:edit)
      end
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        new_attributes = attributes_for(:project, creator_id: user1.id)
        patch project_path(project2.id), params: { project: new_attributes }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH /add_user' do
    it 'adds a user to the project success' do
      patch add_user_project_path(project1.id), params: { project_id: project1.id, user_id: user.id }
      expect(response).to redirect_to(project_path(project1.id))
    end

    it 'fails to add user to project' do
      allow(project1.users).to receive(:<<).and_return(false)
      allow(Project).to receive(:find).and_return(project1)
      allow(User).to receive(:find).and_return(user)
      patch add_user_project_path(project1.id), params: { project_id: project1.id, user_id: user.id }
      expect(flash[:alert]).to eq('Can not add user to project')
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        patch add_user_project_path(project1.id), params: { project_id: project1.id, user_id: user1.id }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH /remove_user' do
    it 'removes a user from the project' do
      patch remove_user_project_path(project1.id), params: { project_id: project1.id, user_id: user.id }
      expect(response).to redirect_to(project_path(project1.id))
    end

    it 'fails to remove user from the project' do
      allow(project1.users).to receive(:destroy).and_return(false)
      allow(Project).to receive(:find).and_return(project1)
      allow(User).to receive(:find).and_return(user)
      patch remove_user_project_path(project1.id), params: { project_id: project1.id, user_id: user.id }
      expect(flash[:alert]).to eq('Can not remove user from project')
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        patch remove_user_project_path(project1.id), params: { project_id: project1.id, user_id: user1.id }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested project' do
      project2 = create(:project, creator_id: user.id)
      expect do
        delete project_path(project2.id)
      end.to change(Project, :count).by(-1)
    end

    it 'fails to destroy the object' do
      allow(project1).to receive(:destroy).and_return(false)
      allow(Project).to receive(:find).and_return(project1)
      delete project_path(project1.id)
      expect(flash[:alert]).to eq('cannot delete the project')
    end

    context 'with authorization' do
      it 'access failure when unauthorized user sign in' do
        delete project_path(project2.id)
        expect(response).to have_http_status(:found)
      end
    end
  end
end
