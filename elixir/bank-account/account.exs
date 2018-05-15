defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = Agent.start(fn -> {:account_open, 0} end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.update(account, fn {_status, balance} -> {:account_closed, balance} end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    Agent.get(account, fn
      {:account_open, balance} -> balance
      {:account_closed, _balance} -> {:error, :account_closed}
    end)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    Agent.get_and_update(account, fn
      {:account_open, balance} = state ->
        balance = balance + amount
        {{:account_open, balance}, {:account_open, balance}}

      {:account_closed, _balance} = state ->
        {{:error, :account_closed}, state}
    end)
  end
end
