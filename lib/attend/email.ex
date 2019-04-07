defmodule Attend.Email do
  import Bamboo.Email

  alias AttendWeb.Endpoint
  alias AttendWeb.Router.Helpers, as: Routes

  defmodule Mailer do
    use Bamboo.Mailer, otp_app: :attend
  end

  def attendance_check(check_id, team, game, player, %{
        yes_token: yes_token,
        no_token: no_token,
        maybe_token: maybe_token
      }) do
    yes = Routes.attendance_url(Endpoint, :update, check_id, token: yes_token)

    no = Routes.attendance_url(Endpoint, :update, check_id, token: no_token)

    maybe = Routes.attendance_url(Endpoint, :update, check_id, token: maybe_token)

    new_email(
      to: player.email,
      from: "reminder@example.com",
      subject: "Are you coming?",
      text_body: """
      Hello #{player.name},

      As a part of "#{team.name}", will you be coming to the
      game at #{game.location} at #{game.start_time}

      Yes: #{yes}
      No: #{no}
      Maybe: #{maybe}

      Thanks,

      Attend
      """
    )
  end
end
