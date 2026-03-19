# spec/requests/swagger/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'Auth', type: :request do
  path '/users' do
    post 'Register a new user' do
      tags        'Auth'
      consumes    'application/json'
      produces    'application/json'
      security    []

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name:                  { type: :string,  example: 'John Doe' },
              email:                 { type: :string,  example: 'john@example.com' },
              password:              { type: :string,  example: 'password123' },
              password_confirmation: { type: :string,  example: 'password123' }
            },
            required: [ 'name', 'email', 'password', 'password_confirmation' ]
          }
        }
      }

      response 201, 'User created' do
        schema type: :object,
          properties: {
            user:  { '$ref' => '#/components/schemas/User' },
            token: { type: :string }
          }
        let(:body) { { user: { name: 'John', email: 'john@example.com', password: 'password123', password_confirmation: 'password123' } } }
        run_test!
      end

      response 422, 'Validation failed' do
        schema '$ref' => '#/components/schemas/Error'
        let(:body) { { user: { name: '', email: 'invalid', password: '123' } } }
        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post 'Login' do
      tags     'Auth'
      consumes 'application/json'
      produces 'application/json'
      security []

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email:    { type: :string, example: 'john@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: [ 'email', 'password' ]
          }
        }
      }

      response 200, 'Login successful' do
        schema type: :object,
          properties: {
            user:          { '$ref' => '#/components/schemas/User' },
            access_token:  { type: :string },
            refresh_token: { type: :string }
          }
        let(:body) { { user: { email: 'john@example.com', password: 'password123' } } }
        run_test!
      end

      response 401, 'Invalid credentials' do
        schema '$ref' => '#/components/schemas/Error'
        let(:body) { { user: { email: 'john@example.com', password: 'wrong' } } }
        run_test!
      end
    end
  end
end
