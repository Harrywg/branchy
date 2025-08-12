defmodule Test.Git do
  use ExUnit.Case
  doctest Branchy

  # Plan for testing

  # 1 write a suite of scripts that generate test repos with different git state
  # 2 there's only 1 test repo at one time in a dir like /_test_repo/*
  # 3 the test repo is destroyed after each use, allowing for it to be replaced
  # 4 each repo needs fake upstream branches somehow
  # 5 use these utils to test the git module

  test "1=1" do
    assert 1 == 1
  end
end
