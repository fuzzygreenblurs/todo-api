class UsersController < ApplicationController
  post "/signup" do
    user = User.create(params)
    halt 400, user.errors.messages if user.invalid?
    redirect to ("/login"), 201
  end

  post "/login" do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      api_response(200, {token: encoded_token(user.id)})
    end

    401
  end

  # for simplicity, users can only get/update/delete their own records
  # if needed, we can include admin authorization to allow these users to access all records
  get "/users/me" do
    api_response(200, { user: current_user })
  end

  # only expose PUT for idempotency, since user records are small. PATCH is unnecessary here.
  put "/users/me/edit" do
    current_user.update(params)
    redirect "/users/me"
  end

  delete "/users/me/delete" do
    api_response(200, {msg: "User deleted"}) if current_user.destroy
  end
end
