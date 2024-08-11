defmodule MailSystemImprovedTest do
  use ExUnit.Case
  doctest MailSystemImproved

  test "greets the world" do
    assert MailSystemImproved.hello() == :world
  end
end
