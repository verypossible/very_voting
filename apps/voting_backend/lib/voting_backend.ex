defmodule VotingBackend do
  @moduledoc """
  Documentation for VotingBackend.
  """

  def get_nominations do
    VotingBackend.NominationProvider.get_nominations(:nomination_provider)
  end

  def get_nomination(nominatorId) do
    Enum.find(get_nominations(), %{}, fn(n) ->
      {:ok, nominator} = Map.fetch(n, "nominator")
       nominator == nominatorId
    end)
  end

  def save_nomination(nomination) do
    VotingBackend.NominationProvider.save_nomination(:nomination_provider, nomination)
  end

  def reset() do
    VotingBackend.NominationProvider.reset(:nomination_provider)
  end
end
