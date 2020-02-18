class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    # admin function only
    # return batch of users based on parameters passed in
  end

  post "/signup" do
    user = User.create(params)
    halt 400, user.errors.messages if user.invalid?
    redirect "/login"
  end

  post "/login" do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      api_response(200, {token: encoded_token})
    end

    401
  end

  # GET: /users/5
  get "/users/:email" do
    user = User.find_by(email: params[:email])
    api_response(200, { user: user.to_json }) if user

    404
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    # admin or self user function only
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
