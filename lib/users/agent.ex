defmodule Flightex.Users.Agent do
  use Agent

  alias Flightex.Users.User

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(user) do
    Agent.update(__MODULE__, &save_user(&1, user))

    {:ok, user}
  end

  def get(id) do
    Agent.get(__MODULE__, &get_user(&1, id))
  end

  defp save_user(state, %User{cpf: cpf} = user) do
    Map.put(state, cpf, user)
  end

  defp get_user(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end
