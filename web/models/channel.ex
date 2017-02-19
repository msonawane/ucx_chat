defmodule UcxChat.Channel do
  use UcxChat.Web, :model

  schema "channels" do
    field :name, :string
    field :topic, :string
    field :type, :integer, default: 0
    field :read_only, :boolean, default: false
    field :archived, :boolean, default: false
    has_many :subscriptions, UcxChat.Subscription
    has_many :clients, through: [:subscriptions, :client]
    has_many :stared_messages, UcxChat.StaredMessage
    has_many :messages, UcxChat.Message
    belongs_to :owner, UcxChat.Client, foreign_key: :client_id

    timestamps(type: :utc_datetime)
  end

  @fields ~w(archived name type topic read_only client_id)a
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:name, :client_id])
  end
end
