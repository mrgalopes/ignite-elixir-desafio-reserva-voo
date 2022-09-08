defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    Agent.update(__MODULE__, &save_booking(&1, booking))

    {:ok, id}
  end

  def get(id) do
    Agent.get(__MODULE__, &get_booking(&1, id))
  end

  def list_all do
    Agent.get(__MODULE__, & &1)
    |> Map.values()
  end

  defp save_booking(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end

  defp get_booking(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
