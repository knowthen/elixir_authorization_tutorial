defmodule WaitListWeb.WaitListLive do
  use Phoenix.LiveView
  import WaitList.Authorization
  alias WaitList.Parties
  alias WaitList.Parties.Party
  alias WaitList.PubSub

  @fields [:id, :name, :size, :status, :inserted_at]

  def mount(_params, session, socket) do
    current_user = Map.take(session["current_user"], [:id, :role, :email])

    if connected?(socket), do: PubSub.subscribe_party()

    parties =
      Parties.list_waiting_parties()
      |> Enum.map(&party_to_map/1)
      |> Enum.sort(&sort_party_asc_inserted_at/2)

    socket =
      assign(socket,
        parties: parties,
        current_user: current_user,
        changeset: Parties.change_party(%Party{}),
        info: nil,
        error: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(WaitListWeb.WaitListView, "index.html", assigns)
  end

  def handle_event("save", %{"party" => party_params}, socket) do
    role = socket.assigns.current_user.role
    
    with true <- can(role) |> create?(Party),
         {:ok, party} <-
           Parties.create_party(party_params) do
      PubSub.broadcast_party(:create, party)
      socket = assign(socket, changeset: Parties.change_party(%Party{}))

      {:noreply, socket}
    else
      false ->
        {:noreply, put_message(socket, :error, "You are not authorized to do this!")}
      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> put_message(:error, "Unable to save party!")
          |> assign(changeset: changeset)

        {:noreply, socket}
    end
  end

  def handle_event("seat", %{"id" => id}, socket) do
    party = Parties.get_party!(id)
    attrs = %{status: :seated}
    role = socket.assigns.current_user.role

    with true <- can(role) |> update?(Party),
         {:ok, party} <- Parties.update_party(party, attrs) do
      PubSub.broadcast_party(:update, party)
      {:noreply, put_message(socket, :info, "Party: #{party.name} seated")}
    else
      false ->
        {:noreply, put_message(socket, :error, "You are not authorized to seat parties!")}
      {:error, %Ecto.Changeset{}} ->
        {:noreply, put_message(socket, :error, "Unable to seat party!")}
    end
  end

  def handle_event("cancel", %{"id" => id}, socket) do
    party = Parties.get_party!(id)
    attrs = %{status: :cancelled}
    role = socket.assigns.current_user.role

    with true <- can(role) |> update?(Party),
         {:ok, party} <- Parties.update_party(party, attrs) do
      PubSub.broadcast_party(:update, party)
      {:noreply, put_message(socket, :info, "Party: #{party.name} canceled")}
    else
      false ->
        {:noreply, put_message(socket, :error, "You are not authorized to cancel parties!")}
      {:error, %Ecto.Changeset{}} ->
        {:noreply, put_message(socket, :error, "Unable to cancel party!")}
    end
  end

  def handle_info({:party, :create, party}, socket) do
    party = party_to_map(party)

    parties =
      [party | socket.assigns.parties]
      |> Enum.sort(&sort_party_asc_inserted_at/2)

    {:noreply, assign(socket, :parties, parties)}
  end

  def handle_info({:party, type, party}, socket) when type in [:update, :delete] do
    case party.status do
      :waiting ->
        {:noreply, socket}

      _ ->
        parties =
          socket.assigns.parties
          |> Enum.reject(fn p -> p.id == party.id end)

        {:noreply, assign(socket, :parties, parties)}
    end
  end

  def handle_info(:clear_messages, socket) do
    {:noreply, clear_messages(socket)}
  end

  defp clear_messages(socket) do
    assign(socket, info: nil, error: nil)
  end

  defp put_message(socket, type, msg) do
    Process.send_after(self(), :clear_messages, 5000)

    socket
    |> clear_messages()
    |> assign(type, msg)
  end

  defp sort_party_asc_inserted_at(a, b), do: a.inserted_at <= b.inserted_at

  defp party_to_map(party, fields \\ @fields) do
    Map.take(party, fields)
  end
end
