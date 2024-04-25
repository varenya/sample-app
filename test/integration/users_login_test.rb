require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "error flash works as expected" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "v@test.com", password: "alsjflsjdf" } }
    assert_response :unprocessable_entity
    assert_select "div.alert-danger"
    get root_path
    assert_select "div.alert-danger", :count => 0
  end
end
