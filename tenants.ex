defmodule TriplexUsage.Tenants do

  alias TriplexUsage.Repo
  alias TriplexUsage.Tenant
  alias TriplexUsage.User
  @tenant_id_key :tenant_id

  def create_tenant do
    schema = Ecto.UUID.generate()
    Triplex.create_schema(schema, Repo, fn _schema, _repo ->
      Triplex.migrate(schema, Repo)

      %Tenant{uuid: schema}
      |> Repo.insert()
    end)
  end

  def add_user_to_tenant(user_email, user_name, schema) do
    tenant = Repo.get_by(Tenant, uuid: schema)

    if tenant do
      user = %User{name: user_name, email: user_email}

      case Repo.insert(user, prefix: tenant.uuid) do
        {:ok, _user} -> {:ok, "User added successfully"}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, "Tenant not found"}
    end
  end

  def list_users(schema) do
    Repo.all(User, prefix: schema)
  end

  def update_user(user_id, schema, attrs) do
    Repo.get(User, user_id, prefix: schema)
    |> case do
      nil -> {:error, "User not found"}
      user ->
        user
        |> User.changeset(attrs)
        |> Repo.update(prefix: schema)
    end
  end

  def get_schema do
    Process.get(@tenant_id_key) || "public"
  end
end
