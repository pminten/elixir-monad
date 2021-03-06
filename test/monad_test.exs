ExUnit.start

import Monad

require ErrorM

defmodule ErrorMonadTest do
  use ExUnit.Case

  # Error Monad
  def error_start() do
    {:ok, :a_value}
  end
  def error_good() do
    {:ok, :another_value}
  end
  def error_bad() do
    {:error, :some_failure}
  end

  test "error monad basics" do
    assert (monad ErrorM do
      ErrorMonadTest.error_start()
    end) == {:ok, :a_value}
  end

  test "error monad bind" do
    assert (monad ErrorM do
      something <- ErrorMonadTest.error_start()
    end) == {:ok, :a_value}
  end

  test "error multi-step bind" do
    assert (monad ErrorM do
      a_value <- ErrorMonadTest.error_start()
      b_value <- ErrorMonadTest.error_good()
      return b_value
    end) == {:ok, :another_value}
  end

  test "error monad return" do
    assert (monad ErrorM do
      return :a_value
    end) == {:ok, :a_value}
  end

  test "error monad fail" do
    assert (monad ErrorM do
      a_value <- ErrorMonadTest.error_start()
      b_value <- ErrorMonadTest.error_bad()
      return a_value
    end) == {:error, :some_failure}
  end

end
