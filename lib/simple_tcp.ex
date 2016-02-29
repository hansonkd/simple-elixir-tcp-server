defmodule SimpleTCP do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(SimpleTCP.Worker, [8000])
    ]

    opts = [strategy: :one_for_one, name: SimpleTCP.Supervisor]
    Supervisor.start_link(children, opts)

  end

end
