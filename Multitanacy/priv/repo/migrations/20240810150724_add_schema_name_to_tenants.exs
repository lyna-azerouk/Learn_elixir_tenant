defmodule TriplexUsage.Repo.Migrations.AddSchemaNameToTenants do
  use Ecto.Migration

  def change do
    alter table(:tenants) do
      add :schema_name, :string
    end
  end
end
