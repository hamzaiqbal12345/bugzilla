require 'rails_helper'

RSpec.describe "Projects", type: :request do

  let(:user) { FactoryBot.create :user }
  let(:project1) { FactoryBot.create(:project, creator_id: user.id ) }
  let(:user_project1) { FactoryBot.create(:users_project, user_id: user.id, project_id: project1.id) }


  describe 'GET /index'  do
    it 'returns status code 200 for getting all project' do
      sign_in user
      get projects_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show'  do
    it 'should return the project with given id' do
      sign_in user
      get project_path(project1.id)
      expect(assigns(:project)).to eql(project1)
    end

    it 'returns status code 200 for showing one project' do
      sign_in user
      get project_path(project1.id)
      expect(response).to have_http_status(:success)
    end

    it 'should render a show template' do
      sign_in user
      get project_path(project1.id)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      sign_in user
      get new_project_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template in response' do
      sign_in user
      get new_project_path
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      sign_in user
      get edit_project_path(project1.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Project' do
        sign_in user
        project_params = attributes_for(:project, creator_id: user.id )
        expect do
          post projects_path, params: { project: project_params }
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the created Project' do
        sign_in user
        project_params = attributes_for(:project, creator_id: user.id )
        post projects_path, params: { project: project_params }
        expect(response). to redirect_to(project_path(Project.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Post' do
        user1 = FactoryBot.create(:user, role: 1)
        sign_in user1
        project_params = attributes_for(:project, creator_id: user1.id )
        expect do
          post projects_path, params: { project: project_params }
        end.to change(Project, :count).by(0)
      end

      it "renders a successful response (i.e to display 'root page')" do
        user1 = FactoryBot.create(:user, role: 1)
        sign_in user1
        project_params = attributes_for(:project, creator_id: user1.id )
        post projects_path, params: { project: project_params }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested project' do
        sign_in user
        new_attributes = attributes_for(:project, creator_id: user.id, title: 'hello world' )
        patch project_path(project1.id), params: { project: new_attributes }
        project1.reload
        # expect(response).to be_successful
      end

      it 'redirects to the project' do
        sign_in user
        new_attributes = attributes_for(:project, creator_id: user.id, title: 'hello world' )
        patch project_path(project1.id), params: { project: new_attributes }
        project1.reload
        expect(response).to redirect_to(project_path(project1.id))
      end
    end

    context 'with invalid parameters' do
      it 'renders a successful response (i-e displays the edit template)' do
        sign_in user
        new_attributes = attributes_for(:project, creator_id: user.id, title: '' )
        patch project_path(project1.id), params: { project: new_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested project' do
      user1 = FactoryBot.create(:user, role: 0)
      sign_in user1
      project2 = FactoryBot.create(:project, creator_id: user1.id )
      expect do
        delete project_path(project2.id)
      end.to change(Project, :count).by(-1)
    end

    it 'fails to destroy the object' do
      user1 = FactoryBot.create(:user, role: 0)
      sign_in user1
      expect do
        delete project_path(project1.id)
      end.to change(Project, :count).by(0)
    end
  end

end


