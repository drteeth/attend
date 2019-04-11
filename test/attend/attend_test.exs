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

    {player_check_id, yes_token} = parse_player_check_id_and_token(alice_email, "Yes")
    {:ok, _} = Attend.confirm_attendance(player_check_id, yes_token, "I'll be 10 minutes late")

    :ok = Attend.start_game(game_id)

    :ok = Attend.end_game(game_id)

    wait_for_event(Events.AttendanceCheckClosed)

    # confirming attendance does not work after the game has ended
    {player_check_id, no_token} = parse_player_check_id_and_token(bob_email, "No")
    {:error, _} = Attend.confirm_attendance(player_check_id, no_token, "I'll be 10 minutes late")

    game_time = DateTime.from_naive!(~N[2018-12-13 21:30:00], "Etc/UTC")
    {:ok, second_game_id} = Attend.schedule_pickup_game(team_id, "Monarch Park - Field 4", game_time)

    :ok = Attend.cancel_game(second_game_id)
    {:ok, _check_id} = Attend.check_attendance(second_game_id, team_id)
    wait_for_event(Events.GameCancelled)
    wait_for_event(Events.AttendanceCheckClosed)

    # confirming attendance does not work after the game has been cancelled
    {player_check_id, no_token} = parse_player_check_id_and_token(bob_email, "No")
    {:error, _} = Attend.confirm_attendance(player_check_id, no_token, "I'll be 10 minutes late")

    # TODO Don't run checks on cancelled games (UH OH)
    # TODO Schedule the start and end of the game when the game is created
  end

  defp last_delivered_email() do
    assert_receive({:delivered_email, email}, 100, Bamboo.Test.flunk_no_emails_received())
    email
  end

  defp parse_player_check_id_and_token(email, answer) do
    pattern =
      ~r{#{answer}: http.+attendance/(?<player_check>[a-z-\d]+).+token=(?<token>[a-z-\d]+)}

    captures = Regex.named_captures(pattern, email.text_body)
    player_check_id = captures["player_check"]
    yes_token = captures["token"]
    {player_check_id, yes_token}
  end
end
