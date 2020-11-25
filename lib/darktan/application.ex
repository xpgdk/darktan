defmodule Darktan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)
    children = [
      # Start the Ecto repository
      # Darktan.Repo,
      # Start the Telemetry supervisor
      DarktanWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Darktan.PubSub},
      # Start the Endpoint (http/https)
      DarktanWeb.Endpoint,
      {Cluster.Supervisor, [topologies, [name: Darktan.ClusterSupervisor]]},
      {Darktan.Store, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Darktan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DarktanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
