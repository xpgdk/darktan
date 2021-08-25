defmodule Darktan.Store do
  @moduledoc """
  Simple distributed in-memory storage system.

  """

  use GenServer

  @pg_group_name __MODULE__

  ## Public API ##

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @spec put(any(), any()) :: any()
  def put(key, value) do
    publish({__MODULE__, :put, key, value})
  end

  @spec get(any()) :: any()
  def get(key) do
    pid =
      :pg2.get_members(@pg_group_name)
      |> List.first()

    GenServer.call(pid, {:get, key})
  end

  @spec list_keys() :: [any()]
  def list_keys() do
    pid =
      :pg2.get_members(@pg_group_name)
      |> List.first()

    GenServer.call(pid, :list_keys)
  end

  ## State module ##
  defmodule State do
    use TypedStruct

    typedstruct do
      field(:content, map(), default: %{})
      field(:peers, [atom()], default: [])
    end

    def new(), do: %__MODULE__{}

    def put(%__MODULE__{content: content} = state, key, value) do
      %{state | content: Map.put(content, key, value)}
    end

    def get(%__MODULE__{content: content}, key, default) do
      Map.get(content, key, default)
    end

    def list_keys(%__MODULE__{content: content}) do
      Map.keys(content)
    end

    def peers(%__MODULE__{peers: peers}), do: peers

    def set_peers(%__MODULE__{} = state, peers) do
      %{state | peers: peers}
    end

    def content(%__MODULE__{content: content}), do: content

    def merge(%__MODULE__{content: content} = state, new_content) do
      %{state | content: Map.merge(content, new_content)}
    end

    @spec key_count(t()) :: non_neg_integer()
    def key_count(%__MODULE__{content: content}), do: Enum.count(content)
  end

  ## Behavioural Functions ##
  @impl true
  @spec init(any) :: {:ok, State.t()}
  def init(_) do
    backend? =
      Application.get_env(:darktan, __MODULE__, [])
      |> Keyword.get(:backend, false)

    :pg2.create(@pg_group_name)

    if backend? do
      :pg2.join(@pg_group_name, self())
      start_timer()
    end

    {:ok, State.new()}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, State.get(state, key, nil), state}
  end

  def handle_call(:list_keys, _from, state) do
    {:reply, State.list_keys(state), state}
  end

  @impl true
  def handle_info({__MODULE__, :put, key, value}, state) do
    state = State.put(state, key, value)
    :telemetry.execute([:darktan, :store], %{key_count: State.key_count(state)})

    {:noreply, state}
  end

  def handle_info({__MODULE__, :request_content, sender}, state) do
    if sender != self() do
      Kernel.send(sender, {__MODULE__, :content, State.content(state)})
    end

    {:noreply, state}
  end

  def handle_info({__MODULE__, :content, content}, state) do
    {:noreply, State.merge(state, content)}
  end

  def handle_info({__MODULE__, :timeout}, state) do
    new_peers = :pg2.get_members(@pg_group_name)

    if State.peers(state) == [] and new_peers != [] do
      IO.puts("Joining new peers")
      publish({__MODULE__, :request_content, self()})
    end

    start_timer()
    {:noreply, State.set_peers(state, new_peers)}
  end

  ## Private Functions ##
  defp publish(msg) do
    :pg2.get_members(@pg_group_name)
    |> Enum.each(fn pid ->
      Kernel.send(pid, msg)
    end)
  end

  def start_timer() do
    Process.send_after(self(), {__MODULE__, :timeout}, 1_000)
  end
end
