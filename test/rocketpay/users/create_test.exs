defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params all valid, returns an user"do
      params = %{
        name: "John",
        password: "1234567",
        nickname: "Perasd",
        age: 22,
        email: "pera@teste.com",
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User,user_id)

      assert %User{name: "John", age: 22,email: "pera@teste.com",nickname: "Perasd", id: ^user_id} = user
    end
  end

    test "when all params are invalid, returns an error"do
      params = %{
        name: "John",
        password: "",
        nickname: "Perasd",
        age: 15,
        email: "pera@teste.com",
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{age: ["must be greater than 17"], password: ["can't be blank"]}

      assert expected_response == errors_on(changeset)
    end
end
