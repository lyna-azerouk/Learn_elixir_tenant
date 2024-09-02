defmodule TriplexUsage.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :uuid, :string
    field :schema_name, :string

    timestamps()
  end

  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:uuid, :schema_name])
    |> validate_required([:uuid])
  end

  def create_tenant() do
    Triplex.create(Ecto.UUID.generate())
  end
end
