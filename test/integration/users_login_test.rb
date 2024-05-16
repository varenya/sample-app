require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end

class InvalidLoginTest < UsersLoginTest
  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end

  test "login with valid username and password" do
    post login_path, params: { session: { email: @user.email, password: 'invalid' } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end

class ValidLogin < UsersLoginTest
  def setup
    super
    post login_path params: { session: { email: @user.email, password: 'password' } }
  end
end

class ValidLoginTest < ValidLogin
  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "redirect after login" do
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
  end
end

class Logout < ValidLogin
  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0
  end
  test "logout in other window" do
    delete logout_path
    assert_redirected_to root_url
  end
end


