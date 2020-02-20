# spec/models/auction_spec.rb
require_relative "../spec_helper"

RSpec.describe List, type: :model do
  let!(:user) do
    User.find_or_create_by(email: "generaltso@email.com") do |user|
      user.first_name = "general"
      user.last_name = "tso"
      user.email = "generaltso@email.com"
      user.password = "goodchicken"
    end
  end

  it "can create list without any associated tasks" do
    list = List.create(user: user)
    expect(List.count).to be(1)
    expect(List.first.tasks.count).to be(0)
  end

  it "can create list with associated tasks" do
    data = {
      list_name: "chores",
      tasks: [ { name: "do dishes" }, { name: "brush my teeth", priority: "medium" }]
    }

    list = List.create(user: user, title: data[:list_name])
    list.assign_tasks(data[:tasks])
    expect(list.tasks.count).to eq(2)
    expect(list.tasks.map(&:name)).to eq(["do dishes", "brush my teeth"])
  end
end