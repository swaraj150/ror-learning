class CustomFailureApp < Devise::FailureApp
  def respond
    self.status = :unauthorized
    self.content_type= "application/json"
    self.response_body = { error: "invalid credentials" }.to_json
  end
end
