require 'swagger_helper'

RSpec.describe 'Tasks', type: :request do
  path '/tasks' do
    get 'List all tasks' do
      tags     'Tasks'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      parameter name: :status,   in: :query, type: :string, required: false, description: 'Filter by status'
      parameter name: :priority, in: :query, type: :string, required: false, description: 'Filter by priority'
      parameter name: :page,     in: :query, type: :integer, required: false, description: 'Page number'

      response 200, 'Tasks retrieved' do
        schema type: :object,
          properties: {
            tasks: {
              type: :array,
              items: { '$ref' => '#/components/schemas/Task' }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                total_pages:  { type: :integer },
                total_count:  { type: :integer }
              }
            }
          }
        let(:Authorization) { "Bearer #{token_for(create(:user))}" }
        run_test!
      end

      response 401, 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end

    post 'Create a task' do
      tags     'Tasks'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title:       { type: :string,  example: 'Complete Rails project' },
              description: { type: :string,  example: 'Finish the API' },
              status:      { type: :string,  example: 'todo' },
              priority:    { type: :string,  example: 'high' },
              due_date:    { type: :string,  example: '2026-04-01' }
            },
            required: [ 'title' ]
          }
        }
      }

      response 201, 'Task created' do
        schema '$ref' => '#/components/schemas/Task'
        let(:Authorization) { "Bearer #{token_for(create(:user))}" }
        let(:body) { { task: { title: 'New task', description: "New task description", priority: 'high', status: "todo", due_date: "2026-04-01" } } }
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Get a task' do
      tags     'Tasks'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      response 200, 'Task found' do
        schema '$ref' => '#/components/schemas/Task'
        let(:current_user) { create(:user) }
        let(:Authorization) { "Bearer #{token_for(current_user)}" }
        let(:id) { create(:task, user: current_user).id }
        run_test!
      end

      response 404, 'Task not found' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { "Bearer #{token_for(create(:user))}" }
        let(:id) { 99999 }
        run_test!
      end
    end

    patch 'Update a task' do
      tags     'Tasks'
      consumes 'application/json'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title:    { type: :string },
              status:   { type: :string },
              priority: { type: :string }
            }
          }
        }
      }

      response 200, 'Task updated' do
        schema '$ref' => '#/components/schemas/Task'
        let(:Authorization) { "Bearer #{token_for(create(:user))}" }
        let(:id)   { create(:task).id }
        let(:body) { { task: { status: 'completed' } } }
        run_test!
      end
    end

    delete 'Delete a task' do
      tags     'Tasks'
      security [ { bearerAuth: [] } ]

      response 200, 'Task deleted' do
        let(:Authorization) { "Bearer #{token_for(create(:user))}" }
        let(:id) { create(:task).id }
        run_test!
      end
    end
  end
end
