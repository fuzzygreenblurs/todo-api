require_relative "spec_helper"

describe ApplicationController do
  it "responds with a welcome message" do
    get '/'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)["data"]["msg"]).to eq("this application is healthy!")
  end

  it "bypasses authorization check for public endpoints" do
    expect_any_instance_of(ApplicationController).not_to receive(:authorize_request!)
    get '/'

    expect_any_instance_of(ApplicationController).not_to receive(:authorize_request!)
    headers = { "ACCEPT" => "application/json" }
    post('/login', { email: "foo", password: "bar" }, headers )

    expect_any_instance_of(ApplicationController).not_to receive(:authorize_request!)
    post('/signup', { first_name: "foo", last_name: "bar", email: "baz" }, headers )
  end

  it "performs authorization check for api endpoints" do
    # all other routes go through authorization
    expect_any_instance_of(ApplicationController).to receive(:authorize_request!)
    get '/users/me'
  end
end
