defmodule MailServer do

  use GenServer

  @moduledoc """
  Módulo que representa un servidor de correos que maneja un registro de usuarios
  y envío de correos entre usuarios.
  """

  @doc """
  Inicia el proceso del servidor de correos.

  ## Examples

      iex> {:ok, server} = MailServer.start_link()
      {:ok, #PID<0.123.0>}

  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Registra un nuevo usuario al servidor de correos

  ## Parámetros
  - `mail_server_pid`: PID del proceso del servidor de correos.
  - `mail_username`: nombre del usuario en el servidor de correos.
  - `mail_username`: PID del proceso del usuario.

  ## Examples

      iex> MailServer.register_user("oscar123", mail_user_1)

  """
  def register_user(mail_username, mail_user_pid) do
    GenServer.call(__MODULE__, {:register_user, mail_username, mail_user_pid})
  end

  @doc """
  Publica un nuevo número de la revista.

  ## Parámetros
  - `mail_server_pid`: PID del proceso del servidor de correos.
  - `message`: Mensaje a enviar
  - `receiver_username`: Nombre del usuario a enviar el mensaje
  """
  def send_mail(message, receiver_username) do
    GenServer.cast(__MODULE__, {:send_mail, message, receiver_username})
  end

  ## Server Callbacks

  @impl true
  @doc """
  Inicializa el state del GenServer.

  ## Parameters

    - `:ok`: Initial state.

  ## Returns

    - `{:ok, state}`: The initial state of the GenServer.

  ## Examples

      iex> {:ok, state} = MailServer.init(:ok)
      {:ok, %{}}

  """
  def init(:ok) do
    {:ok, %{:users=>[]}}
  end

  @impl true
  @doc """
  Handles synchronous requests to add two numbers.

  ## Parameters

    - `{:suma, a, b}`: Tuple containing the operation and the two numbers.
    - `_from`: The process that sent the request.
    - `state`: The current state of the GenServer.

  ## Returns

    - `{:reply, result, state}`: The result of the addition and the current state.

  ## Examples

      iex> {:reply, result, state} = DCalc.handle_call({:suma, 1, 2}, self(), %{})
      {:reply, 3, %{}}

  """
  def handle_call({:register_user, mail_username, mail_user_pid}, _from, state) do
    IO.puts("Registrando usuario #{mail_username} con pid")
    IO.inspect(mail_user_pid)
    state = %{state | users: state.users ++ [{mail_username, mail_user_pid}]}
    IO.inspect(state)
    {:reply, mail_username, state}
  end

  def handle_cast({:send_mail, message, receiver_username}, state) do
    receiver_user = Enum.find(state.users, fn {username, _} ->
      username == receiver_username
    end)

    cond do
      receiver_user == nil ->
        IO.puts("User #{receiver_username} not found")
        {:noreply, state}
      true ->
        {_, user_pid} = receiver_user
        IO.puts("Sending message to: #{receiver_username}...")
        :timer.sleep(1000)
        GenServer.cast(user_pid,{:new_message, message})
        {:noreply, state}
    end
  end

  @impl true
  def handle_call(_, _from, state) do
    IO.puts("Invalid Message")
    {:reply, :ok, state}
  end

end

defmodule MailUser do
  @moduledoc """
  Módulo que representa a un usuario en el servidor de correos.
  """

  use GenServer

  @doc """
  Inicia un proceso de un usuario.

  ## Parámetros
  - `username`: Nombre del usuario.

  ## Examples

      iex> {:ok, user1} = MailUser.start_link(:oscar123)
      {:ok, #PID<0.123.0>}

  """
  def start_link(username) do
    GenServer.start_link(__MODULE__, username, name: username)
  end

  ## Server Callbacks

  @impl true
  @doc """
  Inicializa el state del GenServer.

  ## Parameters

    - `:ok`: Initial state.

  ## Returns

    - `{:ok, state}`: The initial state of the GenServer.

  ## Examples

      iex> {:ok, state} = MailServer.init(:ok)
      {:ok, %{}}

  """
  def init(username) do
    {:ok, %{:username=> username}}
  end

  @impl true
  def handle_cast({:new_message, message}, state) do
    IO.puts("#{state.username} you have received a new message")
    print_message(message)
    {:noreply, state}
  end

  @impl true
  def handle_call(_, _from, state) do
    IO.puts("Invalid Message")
    {:reply, :ok, state}
  end

  def print_message({sender, subject, content}) do
    IO.puts("From: #{sender}")
    IO.puts("Subject: #{subject}")
    IO.puts("Content: #{content}")
  end
end

# Ejemplo de uso
# {:ok, server} = MailServer.start_link()

# {:ok, user1} = MailUser.start_link(:oscar123)
# {:ok, user2} = MailUser.start_link(:santiago321)

# MailServer.register_user("oscar123", user1)
# MailServer.register_user("santiago321", user2)

# MailServer.send_mail({"oscar123","Entregable semana 5", "El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir"}, "santiago321")
# MailServer.send_mail({"santiago321","RE:Entregable semana 5", "Entregable recibido"}, "oscar123")
