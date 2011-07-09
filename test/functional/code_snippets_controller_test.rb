require 'test_helper'

class CodeSnippetsControllerTest < ActionController::TestCase
  setup do
    @code_snippet = code_snippets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:code_snippets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create code_snippet" do
    assert_difference('CodeSnippet.count') do
      post :create, :code_snippet => @code_snippet.attributes
    end

    assert_redirected_to code_snippet_path(assigns(:code_snippet))
  end

  test "should show code_snippet" do
    get :show, :id => @code_snippet.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @code_snippet.to_param
    assert_response :success
  end

  test "should update code_snippet" do
    put :update, :id => @code_snippet.to_param, :code_snippet => @code_snippet.attributes
    assert_redirected_to code_snippet_path(assigns(:code_snippet))
  end

  test "should destroy code_snippet" do
    assert_difference('CodeSnippet.count', -1) do
      delete :destroy, :id => @code_snippet.to_param
    end

    assert_redirected_to code_snippets_path
  end
end
