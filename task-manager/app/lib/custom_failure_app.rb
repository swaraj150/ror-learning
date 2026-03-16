class CustomFailureApp < Devise::FailureApp
  def respond
    self.status = :unauthorized
    self.content = "application/json"
    self.response_body = { error: "invalid credentials" }.to_json
  end
end
