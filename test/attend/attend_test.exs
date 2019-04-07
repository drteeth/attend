defmodule AttendTest do
  use Attend.DataCase
  use Bamboo.Test, shared: true

  alias Attend.Events

  test "" do
    {:ok, team_id} = Attend.register_team("The Noodles")

    {:ok, _player_id} = Attend.add_player_to_team(team_id, "Alice", "alice@example.com")
    {:ok, _player_id} = Attend.add_player_to_team(team_id, "Bob", "bob@example.com")

    {:ok, game_id} =
      Attend.schedule_pickup_game(team_id, "Monarch Park - Field 4", ~N[2019-12-12 21:30:00])

    {:ok, _check_id} = Attend.check_attendance(game_id, team_id)

    wait_for_event(Events.AttendanceRequested)

    assert_receive({:delivered_email, email}, 100, Bamboo.Test.flunk_no_emails_received())

    assert email.from == {nil, "reminder@example.com"}
    assert email.subject == "Are you coming?"

    pattern = ~r{Yes: http.+attendance/(?<player_check>[a-z-\d]+).+token=(?<token>[a-z-\d]+)}
    captures = Regex.named_captures(pattern, email.text_body)
    player_check_id = captures["player_check"]
    yes_token = captures["token"]

    # TODO add reason
    {:ok, _} = Attend.confirm_attendance(player_check_id, yes_token)

    :timer.sleep(1000)
  end
end
