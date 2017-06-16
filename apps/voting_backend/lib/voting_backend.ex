defmodule VotingBackend do
  @moduledoc """
  Documentation for VotingBackend.
  """

  def get_nominations do
    get_nominations_map()
      |> Map.values()
  end

  def get_nomination(nominatorId) do
    case Map.fetch(get_nominations_map(), nominatorId) do
      {:ok, nomination} -> nomination
      :error -> %{}
    end
  end

  def save_nomination(nomination) do
    VotingBackend.NominationProvider.save_nomination(:nomination_provider, nomination)
  end

  def reset() do
    VotingBackend.NominationProvider.reset(:nomination_provider)
  end

  defp get_nominations_map do
    VotingBackend.NominationProvider.get_nominations(:nomination_provider)
  end
end
