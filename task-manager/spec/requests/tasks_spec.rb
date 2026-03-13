require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:user)  { create(:user) }
  let!(:task)  { create(:task, user: user) }

  let(:valid_params) do
    {
      task: {
        title:       'New Task',
        description: 'Task description',
        status:      'pending',
        priority:    1,
        due_date:    1.week.from_now
      }
    }
  end

  let(:invalid_params) { { task: { title: nil, status: nil } } }

  describe 'GET /users/:user_id/tasks' do
    it 'returns all tasks for the user' do
      get "/users/#{user.id}/tasks"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end

    it 'returns 404 if user does not exist' do
      get '/users/99999/tasks'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /users/:user_id/tasks/:id' do
    context 'when task exists' do
      it 'returns the task' do
        get "/users/#{user.id}/tasks/#{task.id}"
        body = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(body['title']).to eq(task.title)
      end
    end

    context 'when task does not exist' do
      it 'returns 404' do
        get "/users/#{user.id}/tasks/99999"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /users/:user_id/tasks' do
    context 'with valid params' do
      it 'creates a task and returns 201' do
        expect {
          post "/users/#{user.id}/tasks", params: valid_params
        }.to change(Task, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'does not create a task and returns 422' do
        expect {
          post "/users/#{user.id}/tasks", params: invalid_params
        }.not_to change(Task, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /users/:user_id/tasks/:id' do
    context 'with valid params' do
      it 'updates the task' do
        patch "/users/#{user.id}/tasks/#{task.id}", params: { task: { title: 'Updated' } }
        expect(response).to have_http_status(:ok)
        expect(task.reload.title).to eq('Updated')
      end
    end

    context 'with invalid params' do
      it 'returns 422' do
        patch "/users/#{user.id}/tasks/#{task.id}", params: { task: { title: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /users/:user_id/tasks/:id' do
    it 'deletes the task' do
      expect {
        delete "/users/#{user.id}/tasks/#{task.id}"
      }.to change(Task, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end