defmodule VotingBackend.NominationProvider do
  use GenServer

  def start_link(name) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    Process.register(pid, name)
    {:ok, pid}
  end

  def init(:ok), do: {:ok, []}

  def handle_call(:get_all_nominations, _from, nominations), do: {:reply, nominations, nominations}
  def handle_cast({:save_nomination, nomination}, nominations), do: {:noreply, nominations ++ [nomination]}
  def handle_cast({:reset}, _), do: {:noreply, []}

  def get_nominations(server), do: GenServer.call(server, :get_all_nominations)
  def save_nomination(server, nomination), do: GenServer.cast(server, {:save_nomination, nomination})
  def reset(server), do: GenServer.cast(server, {:reset})
end
