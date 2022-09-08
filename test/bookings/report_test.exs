defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_from_period/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "given start and end dates, should generate report" do
      param_in_interval = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      param_outside_interval = %{
        complete_date: ~N[2001-06-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00\n"

      [param_in_interval, param_outside_interval]
      |> Enum.each(&Flightex.create_or_update_booking/1)

      Report.generate_from_period(
        ~N[2001-05-01 00:00:00],
        ~N[2001-05-30 00:00:00],
        "report-test-period.csv"
      )

      {:ok, file} = File.read("report-test-period.csv")

      assert file =~ content
    end
  end
end
