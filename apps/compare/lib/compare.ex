defmodule Compare do
  @moduledoc """
  Compare keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Compare.Storage

  def upload(ical, user \\ "0") do
    data = ExIcal.parse(ical)
    file_data = :erlang.term_to_binary(data)
    Storage.persist(file_data, user)
  end

  def compare(user, other) do
    cond do
      !Storage.exists?(user) -> {:error, "#{user} has not uploaded their schedule"}
      !Storage.exists?(other) -> {:error, "#{other} has not uploaded their schedule"}

      true ->
        with {:ok, user_data} <- Storage.read(user),
             {:ok, other_data} <- Storage.read(other) do
          process(:erlang.binary_to_term(user_data), :erlang.binary_to_term(other_data))
        end
    end
  end

  defp process(user, other) do
    user_classes = Enum.map(user, &extract_summary/1) |> Enum.into(MapSet.new)
    other_classes = Enum.map(other, &extract_summary/1) |> Enum.into(MapSet.new)

    %{same: MapSet.intersection(user_classes, other_classes)}
  end

  defp extract_summary(%{summary: summary}) do
    [department, class, _] = String.split(summary)
    "#{department} #{class}"
  end
end

# Below is an example of a complete Event entry
#
#
# %ExIcal.Event{
#   description: "-  If this course is blocked please sign up for the waitlist section. Students will be placed into the class based off our department priority guidelines. For more information please visit: http://www.asia.ubc.ca/undergraduate/department-wait-lists/ (Is the class blocked even though there are a few seats that are free? This is normal. Please check our website for what this means.)\\n\\n",
#   end: %Timex.DateTime{
#     calendar: :gregorian,
#     day: 5,
#     hour: 11,
#     minute: 0,
#     month: 1,
#     ms: 0,
#     second: 0,
#     timezone: %Timex.TimezoneInfo{
#       abbreviation: "PST",
#       from: {:sunday, {{2017, 11, 5}, {1, 0, 0}}},
#       full_name: "America/Vancouver",
#       offset_std: 0,
#       offset_utc: -480,
#       until: {:sunday, {{2018, 3, 11}, {2, 0, 0}}}
#     },
#     year: 2018
#   },
#   rrule: %{
#     freq: "WEEKLY",
#     interval: 1,
#     until: %Timex.DateTime{
#       calendar: :gregorian,
#       day: 6,
#       hour: 23,
#       minute: 59,
#       month: 4,
#       ms: 0,
#       second: 59,
#       timezone: %Timex.TimezoneInfo{
#         abbreviation: "PDT",
#         from: {:sunday, {{2018, 3, 11}, {2, 0, 0}}},
#         full_name: "America/Vancouver",
#         offset_std: 60,
#         offset_utc: -480,
#         until: {:sunday, {{2018, 11, 4}, {1, 0, 0}}}
#       },
#       year: 2018
#     }
#   },
#   stamp: %Timex.DateTime{
#     calendar: :gregorian,
#     day: 12,
#     hour: 18,
#     minute: 0,
#     month: 6,
#     ms: 0,
#     second: 37,
#     timezone: %Timex.TimezoneInfo{
#       abbreviation: "UTC",
#       from: :min,
#       full_name: "UTC",
#       offset_std: 0,
#       offset_utc: 0,
#       until: :max
#     },
#     year: 2018
#   },
#   start: %Timex.DateTime{
#     calendar: :gregorian,
#     day: 5,
#     hour: 10,
#     minute: 0,
#     month: 1,
#     ms: 0,
#     second: 0,
#     timezone: %Timex.TimezoneInfo{
#       abbreviation: "PST",
#       from: {:sunday, {{2017, 11, 5}, {1, 0, 0}}},
#       full_name: "America/Vancouver",
#       offset_std: 0,
#       offset_utc: -480,
#       until: {:sunday, {{2018, 3, 11}, {2, 0, 0}}}
#     },
#     year: 2018
#   },
#   summary: "JAPN 321 001"
# }
