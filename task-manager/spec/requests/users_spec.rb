require 'rails_helper'
RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let(:valid_params)   { { user: { name: 'John', email: 'john@example.com', password: 'foobarbazz' } } }
  let(:invalid_params) { { user: { name: nil, email: nil } } }

  describe 'GET /users' do
    it 'returns all users' do
      get '/users'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe 'GET /users/:id' do
    context 'when user exists' do
      it 'returns the user' do
        get "/users/#{user.id}"
        body = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq(user.name)
      end
    end

    context 'when user does not exist' do
      it 'returns 404' do
        get '/users/99999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end


  describe 'POST /users' do
    context 'with valid params' do
      it 'creates a user and returns 201' do
        expect {
          post '/users', params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'does not create a user and returns 422' do
        expect {
          post '/users', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
  describe 'PATCH /users/:id' do
    context 'with valid params' do
      it 'updates the user' do
        patch "/users/#{user.id}", params: { user: { name: 'Updated', email: user.email, password: user.password } }
        expect(response).to have_http_status(:ok)
        expect(user.reload.name).to eq('Updated')
      end
    end
  end

  describe 'DELETE /users/:id' do
    it 'deletes the user' do
      expect {
        delete "/users/#{user.id}"
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
  
end