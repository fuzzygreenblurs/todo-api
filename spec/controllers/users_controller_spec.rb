require_relative "../spec_helper"

def controller
  UsersController
end

describe UsersController, type: :request do
  before do
    allow(Time).to receive(:now).and_return(Time.new(2020, 2, 19))
    stub_const('ENV', {'JWT_SECRET' => 'MY_JWT_SECRET'})
  end

  let!(:user) do
    User.find_or_create_by(email: "generaltso@email.com") do |user|
      user.first_name = "general"
      user.last_name = "tso"
      user.email = "generaltso@email.com"
      user.password = "goodchicken"
    end
  end

  it "can create new users" do
    user_details = {
      first_name: "foo",
      last_name: "bar",
      password: "secretpassword",
      email: "baz@email.com"
    }

    expect { post('/signup', user_details , {}) }.to change(User, :count).by(1)
    expect(User.last.email).to eq("baz@email.com")
  end

  it "provides a valid auth token upon sign in" do
    user_details = { email: "generaltso@email.com", password: "goodchicken" }
    post('/login', user_details , {"HTTP_ACCEPT" => "application/json"})
    expect(JSON.parse(last_response.body)["data"]["token"]).to eq(user_token(user.id))
  end

  it "current_user can view their public attributes" do
    headers = { "HTTP_AUTHORIZATION" => "Bearer #{user_token(user.id)}" }
    expected_payload = {
      "email" => "#{user.email}",
      "first_name" => "#{user.first_name}",
      "last_name" => "#{user.last_name}"
    }
    get('/users/me', {}, headers)
    expect(JSON.parse(last_response.body)["data"]["user"]).to eq(expected_payload)
  end

  it "current user can update their attributes" do
    headers = { "HTTP_AUTHORIZATION" => "Bearer #{user_token(user.id)}" }
    request_payload = { last_name: "grievous" }

    put('/users/me/edit', { last_name: "grievous" }, headers)
    expect(user.reload.last_name).to eq("grievous")

    # revert name change to ensure tests pass out of order
    put('/users/me/edit', { last_name: "tso" }, headers)
    expect(user.reload.last_name).to eq("tso")
  end

  it "current user can destroy their account" do
    headers = { "HTTP_AUTHORIZATION" => "Bearer #{user_token(user.id)}" }
    delete('/users/me/delete', {} , headers)
    expect(User.find_by(email: "generaltso@email.com")).to be(nil)
  end

  def user_token(user_id)
    payload = {
      issued_at: Time.now.to_i,
      expires_at: Time.now.to_i + 3600,
      identifier: user_id
    }
    
    JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
  end
end