defmodule UcxChat.User do
  @moduledoc false
  use UcxChat.Web, :model
  use Coherence.Schema
  # alias UcxChat.User

  @mod __MODULE__

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :avatar_url, :string
    # field :admin, :boolean, default: false
    field :tz_offset, :integer
    field :alias, :string
    field :chat_status, :string
    field :tag_line, :string
    field :uri, :string
    field :status, :string, default: "offline", virtual: true
    field :active, :boolean, default: true
    field :subscription_hidden, :boolean, virtual: true

    belongs_to :open, UcxChat.Channel, foreign_key: :open_id

    has_many :roles, UcxChat.UserRole, on_delete: :delete_all
    has_many :subscriptions, UcxChat.Subscription, on_delete: :nilify_all
    has_many :channels, through: [:subscriptions, :channel], on_delete: :nilify_all
    has_many :messages, UcxChat.Message, on_delete: :nilify_all
    has_many :stared_messages, UcxChat.StaredMessage, on_delete: :nilify_all
    has_many :owns, UcxChat.Channel, foreign_key: :user_id, on_delete: :nilify_all

    belongs_to :account, UcxChat.Account
    coherence_schema()

    timestamps()
  end

  @all_params ~w(name email username account_id tz_offset alias chat_status tag_line uri open_id active avatar_url)a
  @required  ~w(name email username account_id)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @all_params ++ coherence_fields())
    |> validate_required(@required)
    |> validate_exclusion(:username, [~g"all", ~g"here"])
    |> validate_format(:username, ~r/^[\.a-zA-Z0-9-_]+$/)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_coherence(params)
    |> cast_assoc(:roles)
  end

  def changeset(model, params, _) do
    changeset model, params
  end

  def total_count do
    from u in @mod, select: count(u.id)
  end

  def user_id_and_username(user_id) do
    from u in @mod,
      where: u.id == ^user_id,
      select: {u.id, u.username}
  end
  def user_from_username(username) do
    from u in @mod,
      where: u.username == ^username
  end

  def display_name(%@mod{} = user) do
    user.alias || user.username
  end

  def all do
    from u in @mod
  end

  def tags(user, channel_id) do
    user.roles
    |> Enum.reduce([], fn
      %{role: role, scope: ^channel_id}, acc -> [role | acc]
      %{role: "user"}, acc -> acc
      %{role: role}, acc when role in ~w(bot guest admin) -> [role | acc]
      _, acc -> acc
    end)
    |> Enum.map(&String.capitalize/1)
    |> Enum.sort
  end

  def has_role?(user, role, scope \\ nil) do
    Enum.any?(user.roles, fn
      %{role: ^role, scope: ^scope} -> true
      _ -> false
    end)
  end
end
