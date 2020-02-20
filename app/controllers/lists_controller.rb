class ListsController < ApplicationController

  # GET: /lists
  get "/lists" do
    api_response(200, lists: current_user.lists)
  end

  # POST: /lists
  post "/lists" do
    list = List.create(user: current_user, title: params[:title])
    halt 401 if list.invalid?

    list.assign_tasks(params[:tasks])
    201
  end

  # GET: /lists/5
  get "/lists/:id" do
    list = List.find_by(user_id: current_user.id, id: params[:id])
    halt 404 unless list

    api_response(200, list: list.as_json(include: :tasks))
 end

  # GET: /lists/5/edit
  # get "/lists/:id/edit" do
  #   erb :"/lists/edit.html"
  # end

  # PATCH: /lists/5
  patch "/lists/:id" do
    redirect "/lists/:id"
  end

  # DELETE: /lists/5/delete
  delete "/lists/:id/delete" do
    list = List.find_by(id: params[:id], user_id: current_user.id)
    list.destroy if list
    redirect "/lists"
  end
end
