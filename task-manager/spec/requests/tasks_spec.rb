# spec/requests/tasks_spec.rb
require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let!(:task)      { create(:task, user: user) }
  let!(:other_task) { create(:task, user: other_user) }

  describe 'GET /tasks' do
    before { create_list(:task, 15, user: user) }

    context 'with default pagination' do
      it 'returns first 10 tasks with meta' do
        get '/tasks', headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json['tasks'].length).to eq(10)
        expect(json['meta']['current_page']).to eq(1)
        expect(json['meta']['total_count']).to eq(16)
        expect(json['meta']['total_pages']).to eq(2)
        expect(json['meta']['next_page']).to eq(2)
        expect(json['meta']['prev_page']).to be_nil
      end
    end

    context 'with custom page and per_page' do
      it 'returns correct page and count' do
        get '/tasks', headers: auth_headers(user), params: { page: 2, per_page: 5 }

        json = response.parsed_body
        expect(json['tasks'].length).to eq(5)
        expect(json['meta']['current_page']).to eq(2)
        expect(json['meta']['prev_page']).to eq(1)
      end
    end

    context 'with per_page exceeding max' do
      it 'clamps to max_per_page' do
        get '/tasks', headers: auth_headers(user), params: { per_page: 9999 }

        json = response.parsed_body
        expect(json['meta']['per_page']).to eq(Kaminari.config.max_per_page)
      end
    end

    context 'with invalid page' do
      it 'defaults to page 1' do
        get '/tasks', headers: auth_headers(user), params: { page: -1 }

        json = response.parsed_body
        expect(json['meta']['current_page']).to eq(1)
      end
    end

    context 'on last page' do
      it 'returns nil for next_page' do
        get '/tasks', headers: auth_headers(user), params: { page: 2, per_page: 10 }

        json = response.parsed_body
        expect(json['meta']['next_page']).to be_nil
      end
    end
  end

  describe "GET /tasks/:id" do
    it "returns own task" do
      get "/tasks/#{task.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /tasks" do
    it "creates task for current user" do
      post "/tasks", headers: auth_headers(user), params: {
        task: { title: "New task", description: "desc", status: "pending", due_date: 1.weeks.from_now, priority: 1 }
      }
      expect(response).to have_http_status(:created)
      expect(Task.last.user_id).to eq(user.id)
    end
  end

  describe "DELETE /tasks/:id" do
    it "deletes own task" do
      expect {
        delete "/tasks/#{task.id}", headers: auth_headers(user)
      }.to change(Task, :count).by(-1)
    end
  end
end
