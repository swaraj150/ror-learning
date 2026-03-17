# spec/requests/tasks_spec.rb
require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let!(:task)      { create(:task, user: user) }
  let!(:other_task) { create(:task, user: other_user) }

  describe "GET /tasks" do
    it "returns only current user tasks" do
      get "/tasks", headers: auth_headers(user)
      json = JSON.parse(response.body)
      ids = json.map { |t| t["id"] }
      expect(ids).to include(task.id)
      expect(ids).not_to include(other_task.id)
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
