defmodule VotingBackendTest do
  use ExUnit.Case
  import VotingBackend
  doctest VotingBackend

  setup do
    reset()
    nomination = %{"nominator" => "test@test.com", "nominatorName" => "Test User", "nominee" => "Test User"}
    save_nomination(nomination)
    [nomination: nomination]
  end

  test "get_nominations/0", %{nomination: nomination} do
    assert get_nominations() == [nomination]
  end

  test "get_nomination/1 success", %{nomination: nomination} do
    assert get_nomination("test@test.com") == nomination
  end

  test "get_nomination/1 failure", _ do
    assert get_nomination("fail@test.com") == %{}
  end

  test "save_nomination/1", _ do
    nomination = %{"nominator" => "test2@test.com", "nominatorName" => "Test 2 User", "nominee" => "Test User"}
    save_nomination(nomination)
    assert length(get_nominations()) == 2
  end

  test "reset/0", _ do
    reset()
    assert length(get_nominations()) == 0
  end
end
