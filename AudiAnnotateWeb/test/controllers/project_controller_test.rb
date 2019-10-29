require 'test_helper'

class ProjectControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get project_all_url
    assert_response :success
  end

end
