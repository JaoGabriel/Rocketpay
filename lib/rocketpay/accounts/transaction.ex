defmodule Rocketpay.Accounts.Transaction do

  alias Ecto.Multi
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  def call(%{"from" => from_id,"to" => to_id, "value" => value}) do
    withdrawl_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

      Multi.new()
      |> Multi.merge(fn _changes -> Operation.call(withdrawl_params, :withdrawl) end)
      |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
      |> run_transaction()
  end

  defp build_params(id,value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation,reason,_changes} -> {:error, reason}

      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account,to_account)}
    end
  end

end
