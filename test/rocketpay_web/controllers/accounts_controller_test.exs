defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account,User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "John",
        password: "1234567",
        nickname: "Perasd",
        age: 22,
        email: "pera@teste.com",
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "60.0"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit,account_id,params))
        |> json_response(:ok)

        assert %{"account" => %{"balance" => "60.00","id" => _id},"message" => "Ballance update sucessfully"} = response
    end

    test "when there are params invalid, return error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit,account_id,params))
        |> json_response(:bad_request)

        expected_response = %{"message" => "Invalid deposit value!"}

        assert expected_response == response
    end

  end
end
