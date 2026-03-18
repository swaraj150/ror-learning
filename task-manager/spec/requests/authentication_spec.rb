require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let!(:user) { create(:user) }
  def error_message = response.parsed_body['error']['message']

  describe "protected routes" do
    context "with no token" do
      it "returns 401" do
        get "/tasks"
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        get "/tasks"
        expect(error_message).to eq("No token provided")
      end
    end

    context "with invalid token" do
      it "returns 401" do
        get "/tasks", headers: { "Authorization" => "Bearer invalidtoken" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with expired token" do
      it "returns 401" do
        expired_token = JwtService.encode_access({ user_id: user.id, exp: 1.hour.ago.to_i })
        get "/tasks", headers: { "Authorization" => "Bearer #{expired_token}" }
        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq("Your session has expired, please log in again")
      end
    end

    context "with valid token" do
      it "allows access" do
        get "/tasks", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /users/refresh" do
    context "with valid refresh token" do
      before do
        post "/users/sign_in", params: {
          user: { email: user.email, password: "password123" }
        }
        @refresh_token = JSON.parse(response.body)["refresh_token"]
      end

      it "returns a new access token" do
        post "/users/refresh", headers: { "Authorization" => "Bearer #{@refresh_token}" }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["access_token"]).to be_present
      end
    end

    context "with access token instead of refresh token" do
      it "returns 401" do
        post "/users/refresh", headers: auth_headers(user)
        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq("Invalid token type")
      end
    end

    context "with revoked refresh token" do
      it "returns 401" do
        user.update_column(:refresh_token, nil)
        revoked_token = JwtService.encode_refresh({ user_id: user.id })
        post "/users/refresh", headers: { "Authorization" => "Bearer #{revoked_token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
