defmodule Compare.Application do
  @moduledoc """
  The Compare Application Service.

  The compare system business domain lives in this application.

  Exposes API to clients such as the `CompareWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Compare.Supervisor)
  end
end
