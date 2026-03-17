require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  let!(:user) { create(:user, password: "password123") }

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      before do
        post "/users/sign_in", params: {
          user: { email: user.email, password: "password123" }
        }
      end

      it "returns 200 ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns access token" do
        json = JSON.parse(response.body)
        expect(json["access_token"]).to be_present
      end

      it "returns refresh token" do
        json = JSON.parse(response.body)
        expect(json["refresh_token"]).to be_present
      end

      it "stores refresh token in database" do
        expect(user.reload.refresh_token).to be_present
      end

      it "returns user data" do
        json = JSON.parse(response.body)
        expect(json["user"]["email"]).to eq(user.email)
      end

      it "does not expose sensitive fields" do
        json = JSON.parse(response.body)
        expect(json["user"]).not_to include("encrypted_password", "refresh_token")
      end
    end

    context "with invalid credentials" do
      it "returns 401 with wrong password" do
        post "/users/sign_in", params: {
          user: { email: user.email, password: "wrongpassword" }
        }
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns 401 with wrong email" do
        post "/users/sign_in", params: {
          user: { email: "wrong@example.com", password: "password123" }
        }
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post "/users/sign_in", params: {
          user: { email: user.email, password: "wrong" }
        }
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "clears refresh token from database" do
      user.update_column(:refresh_token, "sometoken")
      delete "/users/sign_out", headers: auth_headers(user)
      expect(user.reload.refresh_token).to be_nil
    end

    it "returns 200 ok" do
      delete "/users/sign_out", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
