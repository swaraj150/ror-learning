require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          name:                  "John",
          email:                 "john@example.com",
          password:              "password123",
          password_confirmation: "password123"
        }
      }
    end
    def error_message = response.parsed_body['error']['message']

    context "with valid params" do
      it "creates a new user" do
        expect {
          post "/users", params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns 201 created" do
        post "/users", params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "returns user data without sensitive fields" do
        post "/users", params: valid_params
        json = JSON.parse(response.body)
        expect(json["user"]).to include("id", "name", "email")
        expect(json["user"]).not_to include("encrypted_password", "refresh_token")
      end

      it "assigns default user role" do
        post "/users", params: valid_params
        expect(User.last.role).to eq("user")
      end
    end

    context "with invalid params" do
      it "returns 422 when email already taken" do
        create(:user, email: "john@example.com")
        post "/users", params: valid_params
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns errors when password too short" do
        post "/users", params: { user: valid_params[:user].merge(password: "short", password_confirmation: "short") }
        expect(response).to have_http_status(:unprocessable_content)
        expect(error_message).to be_present
      end

      it "returns 422 when name is missing" do
        post "/users", params: { user: valid_params[:user].merge(name: "") }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns 422 when password confirmation doesn't match" do
        post "/users", params: { user: valid_params[:user].merge(password_confirmation: "wrongpass") }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
  describe "PATCH /users" do
    let!(:user) { create(:user) }

    context "with valid params" do
      it "updates the user name" do
        patch "/users",
          params: { user: { name: "Updated Name" } },
          headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        expect(user.reload.name).to eq("Updated Name")
      end
    end

    context "with invalid params" do
      it "returns 422 when email already taken" do
        other_user = create(:user)
        patch "/users",
          params: { user: { email: other_user.email } },
          headers: auth_headers(user)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns 422 when name is blank" do
        patch "/users",
          params: { user: { name: "" } },
          headers: auth_headers(user)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "without authentication" do
      it "returns 401" do
        patch "/users", params: { user: { name: "Updated" } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /users" do
    let!(:user) { create(:user) }

    context "when authenticated" do
      it "deletes the user account" do
        expect {
          delete "/users", headers: auth_headers(user)
        }.to change(User, :count).by(-1)
      end

      it "returns 200 ok" do
        delete "/users", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it "also deletes associated tasks" do
        create_list(:task, 3, user: user)
        expect {
          delete "/users", headers: auth_headers(user)
        }.to change(Task, :count).by(-3)
      end

      it "cannot access account after deletion" do
        delete "/users", headers: auth_headers(user)
        expect(User.find_by(id: user.id)).to be_nil
      end
    end

    context "without authentication" do
      it "returns 401" do
        delete "/users"
        expect(response).to have_http_status(:unauthorized)
      end

      it "does not delete any user" do
        expect {
          delete "/users"
        }.not_to change(User, :count)
      end
    end
  end
end
