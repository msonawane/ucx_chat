defmodule UcxChat.TypingChannelController do
  import UcxChat.ChannelController
  alias UcxChat.{TypingAgent, MessageService}

  require Logger

  @module __MODULE__
  @module_name inspect(@module)

  def create(%{assigns: %{channel_id: channel_id, client_id: client_id, nickname: nickname, room: room}} = socket, params) do
    Logger.warn "#{@module_name} create params: #{inspect params}, socket: #{inspect socket}"
    TypingAgent.start_typing(channel_id, client_id, nickname)
    MessageService.update_typing(channel_id, room)
    {:noreply, socket}
  end

  def delete(socket, params) do

    # TypingAgent.stop_typing(channel_id, client_id)
    # MessageService.update_typing(channel_id, room)

    {:noreply, socket}
  end

end
