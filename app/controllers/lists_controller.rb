class ListsController < ApplicationController

  # GET: /lists
  get "/lists" do
    erb :"/lists/index.html"
  end

  # POST: /lists
  post "/lists" do
    user = User.find_by_id_or_email(params[:user_id], params[:user_email])
    halt 400 if @user.nil?

    list = List.new
    list.assign(user_id: user.id, tasks: params)
    # list.user_id = user.id
    # list.tasks = params
    list.save

    # {
    #   list_name: "chores",
    #   tasks: [
    #     {
    #       name: "clean room",
    #       completed: false
    #     },
    #     {
    #       ...
    #     }
    #   ]
    # }
  end

  # GET: /lists/5
  get "/lists/:id" do
    erb :"/lists/show.html"
  end

  # GET: /lists/5/edit
  get "/lists/:id/edit" do
    erb :"/lists/edit.html"
  end

  # PATCH: /lists/5
  patch "/lists/:id" do
    redirect "/lists/:id"
  end

  # DELETE: /lists/5/delete
  delete "/lists/:id/delete" do
    redirect "/lists"
  end
end
