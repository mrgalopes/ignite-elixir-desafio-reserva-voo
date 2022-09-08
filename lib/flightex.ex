defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Users.Agent, as: UserAgent

  def start_agents do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})
  end

  defdelegate create_or_update_booking(params), to: CreateOrUpdateBooking, as: :call
end
