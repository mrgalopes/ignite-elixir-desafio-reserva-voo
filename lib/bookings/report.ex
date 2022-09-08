defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename) do
    bookings =
      BookingAgent.list_all()
      |> Enum.map(&to_booking_string/1)

    File.write!(filename, bookings)
  end

  def generate_from_period(from_date, to_date, filename \\ "report-period.csv") do
    bookings =
      BookingAgent.list_from_period(from_date, to_date)
      |> Enum.map(&to_booking_string/1)

    File.write!(filename, bookings)
  end

  defp to_booking_string(%Booking{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
