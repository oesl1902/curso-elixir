defmodule MailServer do

  use GenServer

  @moduledoc """
  Servidor de correos que maneja un registro de usuarios
  y envío de correos entre usuarios.
  """

  @doc """
  Inicia el proceso del servidor de correos.

  ## Examples

      iex> MailServer.start_server()
      #PID<0.123.0>

  """
  def start_server do
    IO.puts("Servidor de correos iniciado")
    {:ok,mail_server_pid} = GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    mail_server_pid
  end

  @impl true
  @doc """
  Inicializa el state del GenServer.

  ## Parameters

    - `:ok`: Initial state.

  ## Returns

    - `{:ok, state}`: The initial state of the GenServer.

  ## Examples

      iex> {:ok, state} = MailServer.init(:ok)
      {:ok, %{:users=>[]}}

  """
  def init(:ok) do
    {:ok, %{:users=>[]}}
  end

  @impl true
  @doc """
  Recibe solicitudes sincronas para registrar usuarios en el servidor de correos

  ## Parameters

    - `{:register_user, user}`: Tupla que contiene el MailUser a registrar.
    - `_from`: El proceso que envió la petición.
    - `state`: El estado actual del GenServer.

  ## Returns

    - `{:reply, :user_registered, state}`: El resultado del registro del MailUser.

  """
  def handle_call({:register_user, user}, _from, state) do
    IO.puts("Usuario #{user.name} registrado")
    state = %{state | users: state.users ++ [user]}
    {:reply, :user_registered, state}
  end

  @doc """
  Recibe solicitudes asincronas para enviar un correo al usuario destinatario

  ## Parameters

    - `{:send_mail, message, receiver_username}`: Tupla que contiene el MailMessage y el username del usuario que va a recibir el mensaje.
    - `state`: El estado actual del GenServer.

  ## Returns

    - `{:noreply, state}`: El resultado del envío del mensaje.

  """
  @impl true
  def handle_cast({:send_mail, message, receiver_username}, state) do
    receiver_user = Enum.find(state.users, fn user ->
      user.username == receiver_username
    end)

    cond do
      receiver_user == nil ->
        IO.puts("Usuario #{receiver_username} no encontrado")
        {:noreply, state}
      true ->
        IO.puts("Enviando mensaje a: #{receiver_user.name}...")
        :timer.sleep(1000)
        GenServer.cast(receiver_user.pid,{:new_message, message})
        {:noreply, state}
    end
  end

end

# iex -S mix
# MailServer.start_server()
# user1 = MailUser.new("oscar123","Oscar Eduardo Sanchez")
# user2 = MailUser.new("santiago123","Santiago Posada")
# user3 = MailUser.new("johnd02","John Doe")
# message1 = MailMessage.new("oscar123","santiago123","Entregable semana 5","El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir")
# MailUser.send_message(message1)
# message2 = MailMessage.new("santiago123","oscar123","RE:Entregable semana 5","Entregable recibido")
# MailUser.send_message(message2)
# message3 = MailMessage.new("johnd02","santiago123","Duda entregable","Hola, dónde puedo encontrar ejemplos")
# MailUser.send_message(message3)
# message4 = MailMessage.new("santiago123","johnd02","RE:Duda entregable","Hola, en el repo https://github.com/santiagoposadag/Curso_BCB_Elixir_semana5-pt1")
# MailUser.send_message(message4)
