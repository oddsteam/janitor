require "test_helper"

class ReservesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reserve = reserves(:one)
  end

  test "should get index" do
    get reserves_url
    assert_response :success
  end

  test "should get new" do
    get new_reserve_url
    assert_response :success
  end

  test "should create reserve" do
    assert_difference("Reserve.count") do
      post reserves_url, params: { reserve: { date: @reserve.date, end_timer: @reserve.end_timer, note: @reserve.note, start_timer: @reserve.start_timer } }
    end

    assert_redirected_to reserve_url(Reserve.last)
  end

  test "should show reserve" do
    get reserve_url(@reserve)
    assert_response :success
  end

  test "should get edit" do
    get edit_reserve_url(@reserve)
    assert_response :success
  end

  test "should update reserve" do
    patch reserve_url(@reserve), params: { reserve: { date: @reserve.date, end_timer: @reserve.end_timer, note: @reserve.note, start_timer: @reserve.start_timer } }
    assert_redirected_to reserve_url(@reserve)
  end

  test "should destroy reserve" do
    assert_difference("Reserve.count", -1) do
      delete reserve_url(@reserve)
    end

    assert_redirected_to reserves_url
  end
end
