  require_relative "../spec_helper"

  describe ListsController, type: :request do
    let!(:user) do
      User.find_or_create_by(email: "generaltso@email.com") do |user|
        user.first_name = "general"
        user.last_name = "tso"
        user.email = "generaltso@email.com"
        user.password = "goodchicken"
      end
    end

    let!(:headers) { { "HTTP_AUTHORIZATION" => "Bearer #{user_token(user.id)}" } }

    before do
      allow(Time).to receive(:now).and_return(Time.new(2020, 2, 19))
      setup_user_lists
    end

    it "users can view their lists with tasks optionally" do
      get('/lists', {}, headers)
      response_lists = JSON.parse(last_response.body)["data"]["lists"].map {|list| list["title"]}
      expect(response_lists.sort).to eq(["has no tasks", "has tasks"])

      # TO_DO
      # get('/lists?include=tasks', {}, headers)
    end

    it "users can get a list and its associated tasks" do
      target_list = List.last
      get("/lists/#{target_list.id}", {}, headers)

      response_list = JSON.parse(last_response.body)["data"]["list"]
      expect(response_list["id"]).to eq(target_list.id)
      expect(response_list["title"]).to eq(target_list.title)
      expect(response_list["tasks"].count).to eq(target_list.tasks.count)
    end

    it "users can delete owned list and its associated tasks" do
      target_list = List.find_by(title: "has tasks")
      target_tasks = target_list.tasks.pluck(:id)

      delete("/lists/#{target_list.id}/delete", {} , headers)
      expect(List.find_by(id: target_list.id)).to be(nil)
      expect(Task.where(id: target_tasks).count).to be(0)
    end

    it "users cannot delete unowned list" do
      target_list = List.find_by(title: "has tasks")
      target_tasks = target_list.tasks.pluck(:id)

      unauthorized_user = User.create({
        email: "generalgreivous@email.com",
        first_name: "general",
        last_name: "grievous",
        email: "generalgrievous@email.com",
        password: "foursabers"
      })

      unauthorized_user_headers = {
        "HTTP_AUTHORIZATION" => "Bearer #{user_token(unauthorized_user.id)}"
      }

      delete("/lists/#{target_list.id}/delete", {} , unauthorized_user_headers)
      expect(List.find_by(id: target_list.id)).not_to be(nil)
      expect(Task.where(id: target_tasks).count).not_to be(0)
    end

    it "users can update existing tasks or add new tasks to list" do


    end

    def setup_user_lists
      list_without_tasks = { title: "has no tasks" }
      post('/lists', list_without_tasks, headers)
      expect(user.reload.lists.count).to eq(1)

      list_with_tasks = {
        title: "has tasks",
        tasks: [ { name: "brush my teeth", priority: "low" } ]
      }

      post('/lists', list_with_tasks, headers)
      expect(user.reload.lists.count).to eq(2)
      expect(user.tasks.count).to eq(1)
    end

    def user_token(user_id)
      stub_const('ENV', {'JWT_SECRET' => 'MY_JWT_SECRET'})

      payload = {
        issued_at: Time.now.to_i,
        expires_at: Time.now.to_i + 3600,
        identifier: user_id
      }

      JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    end
  end