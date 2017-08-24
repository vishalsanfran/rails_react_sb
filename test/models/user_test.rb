require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end
  test "should be valid" do
    assert @user.valid?
  end
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.name = "a"*251 + "@example.com"
    assert_not @user.valid?
  end
  test "reject invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be invalid"
    end
  end
  test "email addresses should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end
  test "save email addrs in lowercase" do
    mix_case_email = "vKK@exAmPle.com"
    @user.email = mix_case_email
    @user.save
    assert_equal mix_case_email.downcase, @user.reload.email
  end
end
