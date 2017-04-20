defmodule Hobot.Input.TwitterStreaming.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Hobot.Input.TwitterStreaming.Worker.start_link(arg1, arg2, arg3)
      # worker(Hobot.Input.TwitterStreaming.Worker, [arg1, arg2, arg3]),
      worker(Hobot.Input.TwitterStreaming, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :simple_one_for_one, name: Hobot.Input.TwitterStreaming.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
