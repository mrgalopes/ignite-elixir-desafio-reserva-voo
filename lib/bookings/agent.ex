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

  def list_from_period(from_date, to_date) do
    Agent.get(__MODULE__, & &1)
    |> Map.values()
    |> Enum.filter(&is_inside_period(&1, from_date, to_date))
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

  defp is_inside_period(%Booking{complete_date: date}, from_date, to_date) do
    is_after(date, from_date) and is_before(date, to_date)
  end

  defp is_after(date, to_date) do
    case Date.compare(date, to_date) do
      :gt -> true
      :eq -> true
      :lt -> false
    end
  end

  defp is_before(date, from_date) do
    case Date.compare(date, from_date) do
      :lt -> true
      :eq -> true
      :gt -> false
    end
  end
end
