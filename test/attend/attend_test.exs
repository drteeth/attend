defmodule AttendTest do
  use Attend.DataCase
  use Bamboo.Test, shared: true

  alias Attend.Events

  test "" do
    {:ok, team_id} = Attend.register_team("The Noodles")

    {:ok, _player_id} = Attend.add_player_to_team(team_id, "Alice", "alice@example.com")
    {:ok, _player_id} = Attend.add_player_to_team(team_id, "Bob", "bob@example.com")

    game_time = DateTime.from_naive!(~N[2018-12-12 21:30:00], "Etc/UTC")
    {:ok, game_id} = Attend.schedule_pickup_game(team_id, "Monarch Park - Field 4", game_time)

    {:ok, _check_id} = Attend.check_attendance(game_id, team_id)

    wait_for_event(Events.AttendanceRequested)

    alice_email = last_delivered_email()
    bob_email = last_delivered_email()

    assert alice_email.to == [{"Alice", "alice@example.com"}]
    assert alice_email.from == {nil, "reminder@example.com"}
    assert alice_email.subject == "Are you coming?"

    assert bob_email.to == [{"Bob", "bob@example.com"}]
    assert bob_email.from == {nil, "reminder@example.com"}
    assert bob_email.subject == "Are you coming?"

    pattern = ~r{Yes: http.+attendance/(?<player_check>[a-z-\d]+).+token=(?<token>[a-z-\d]+)}
    captures = Regex.named_captures(pattern, alice_email.text_body)
    player_check_id = captures["player_check"]
    yes_token = captures["token"]

    {:ok, _} = Attend.confirm_attendance(player_check_id, yes_token, "I'll be 10 minutes late")

    :ok = Attend.start_game(game_id)

    :ok = Attend.end_game(game_id)

    # TODO End the game and close the attendance check
    # TODO Schedule the start and end of the game when the game is created
    # TODO Cancel the game (and the scheduled timer)
    # -> Cancel any running checks - Don't run checks on cancelled games (UH OH)
  end

  defp last_delivered_email() do
    assert_receive({:delivered_email, email}, 100, Bamboo.Test.flunk_no_emails_received())
    email
  end
end
