defmodule WaitList.PubSub do
  alias Phoenix.PubSub

  @topic "party"

  def subscribe_party() do
    PubSub.subscribe(WaitList.PubSub, @topic)
  end

  def broadcast_party(type, party) when type in [:create, :update, :delete] do
    message = {:party, type, party}
    PubSub.broadcast(WaitList.PubSub, @topic, message)
  end
end
