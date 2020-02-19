require_relative "spec_helper"

def controller
  UsersController
end

describe UsersController do

  let (:user) do
    User.create({
      first_name: "general",
      last_name: "tso",
      email: "generaltso@email.com",
      password: "goodchicken"
    })
  end

  let(:headers) { { "ACCEPT" => "application/json" } }

  it "can create new users" do
    user_details = {
      first_name: "foo",
      last_name: "bar",
      password: "secretpassword",
      email: "baz@email.com"
    }

    expect { post('/signup', user_details , headers ) }.to change(User, :count).by(1)
    expect(User.last.email).to eq("baz@email.com")
  end

  it "provides a valid auth token upon sign in" do
    allow(Time).to receive(:now).and_return(Time.now)
    stub_const('ENV', {'JWT_SECRET' => 'MY_JWT_SECRET'})

    payload = {
      issued_at: Time.now.to_i,
      expires_at: Time.now.to_i + 3600,
      identifier: user.id
    }

    expected_token = JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')

    user_details = { email: user.email, password: user.password }
    post('/login', user_details , headers )
    expect(JSON.parse(last_response.body)["data"]["token"]).to eq(expected_token)
  end
end