defmodule Darktan.MixProject do
  use Mix.Project

  def project do
    [
      app: :darktan,
      version: "0.1.5",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Darktan.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:typed_struct, "~> 0.2.1"},
      {:phoenix, "~> 1.5.7"},
      {:swarm, "~> 3.4"},
      {:libcluster, "~> 3.2"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:telemetry_metrics_cloudwatch, "~> 0.3.1"},
      {:telemetry_metrics_prometheus, "~> 0.6.0"},
      {:ex_aws_sts, "~> 2.1"},
      {:hackney, "~> 1.16"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:poison, "~> 4.0"},
      {:configparser_ex, "~> 4.0"},
      {:sweet_xml, "~> 0.6.6"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
    ]
  end
end
