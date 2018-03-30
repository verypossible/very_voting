defmodule VotingWeb.VotingChannel do
  use Phoenix.Channel

  def join("election:vote", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("save_nomination", nomination, socket) do
    VotingBackend.save_nomination(nomination)
    broadcast_nominations(socket)
  end

  def handle_in("get_nominations", _payload, socket) do
    broadcast_nominations(socket)
  end

  def handle_in("get_nomination", %{"nominator" => nominator}, socket) do
    broadcast! socket, "load_nomination", VotingBackend.get_nomination(nominator)
    {:noreply, socket}
  end

  def handle_in("reset_election", _payload, socket) do
    VotingBackend.reset()
    broadcast! socket, "load_nomination", VotingBackend.get_nomination("")
    broadcast_nominations(socket)
  end

  defp broadcast_nominations(socket) do
    broadcast! socket, "load_nominations", %{nominations: VotingBackend.get_nominations()}
    {:noreply, socket}
  end
end
