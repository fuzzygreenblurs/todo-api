class ListsController < ApplicationController

  get "/lists" do
    api_response(200, lists: current_user.lists)
  end

  post "/lists" do
    list = List.create(user: current_user, title: params[:title])
    halt 401 if list.invalid?

    list.assign_tasks(params[:tasks])
    201
  end

  get "/lists/:list_id" do
    list = List.find_by(user_id: current_user.id, id: params[:list_id])
    halt 404 unless list

    api_response(200, list: list.as_json(include: :tasks))
  end

  put "/lists/:list_id" do
    if list = List.find_by(id: params[:list_id], user: current_user)
      list.update(title: params[:title])
      list.assign_tasks(params[:tasks])
      redirect "/lists/#{params[:list_id]}"
    end

    400
  end

  delete "/lists/:list_id" do
    list = List.find_by(id: params[:list_id], user_id: current_user.id)
    list.destroy if list
    redirect "/lists"
  end
end
