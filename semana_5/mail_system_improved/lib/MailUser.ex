defmodule MailUser do

  @moduledoc """
  Usuario del servidor de correos.
  """

  use GenServer

  @impl true
  @doc """
  Inicializa el state del GenServer.

  ## Parameters

    - `:ok`: Initial state.

  ## Returns

    - `{:ok, state}`: The initial state of the GenServer.

  ## Examples

      iex> {:ok, state} = MailServer.init("oscar123")
      {:ok, %{username: "oscar123"}}

  """
  def init(username) do
    {:ok, %{:username => username}}
  end

  @enforce_keys [:username, :pid]
  defstruct [:username, :pid, :name]

  @doc """
  Crea un nuevo usuario en el servidor de correos.

  ## Parameters
  - `username`: String, nombre del usuario en el servidor de correos (requerido)
  - `name`: String, nombre y apellido del usuario (requerido)

  ## Returns
  - `%MailUser{}`: Una nuevo struct del MailUser

  ## Examples
      iex> user1 = MailUser.new("oscar123","Oscar Eduardo Sanchez")
      Usuario Oscar Eduardo Sanchez registrado
      %MailUser{username: "oscar123", pid: #PID<0.165.0>, name: "Oscar Eduardo Sanchez"}

      iex> user2 = MailUser.new("santiago123","Santiago Posada")
      Usuario Santiago Posada registrado
      %MailUser{username: "santiago123", pid: #PID<0.166.0>, name: "Santiago Posada"}
  """
  def new(username, name) do
    {_,pid} = init_user_server(username)
    mail_user = struct!(__MODULE__, [username: username, pid: pid, name: name])
    register_in_server(mail_user)
    mail_user
  end

  @doc """
  Inicia el proceso que recibe los mensajes del servidor de correos.

  ## Parameters
  - `username`: String, nombre del usuario en el servidor de correos (requerido)

  ## Returns
  - `PID`: Id del proceso donde se van a recibir los correos

  ## Examples

      iex> MailUser.init_user_server("oscar123")
      #PID<0.127.0>

  """
  def init_user_server(username) do
    GenServer.start_link(__MODULE__, username, name: String.to_atom(username))
  end


  @doc """
  Envía un mensaje al proceso del servidor de correos para registrar al usuario en su lista de usuarios.

  ## Parameters
  - `mail_user`: MailUser, struct del usuario a registrar en el servidor de correos (requerido)

  ## Examples

      iex> MailUser.register_in_server(mail_user)
      Usuario Santiago Posada registrado

  """
  def register_in_server(mail_user) do
    GenServer.call(MailServer, {:register_user, mail_user})
  end

  @doc """
  Envía un correo a través del servidor de correos para el destinatario.

  ## Parameters
  - `mail_user`: MailUser, struct del usuario a registrar en el servidor de correos (requerido)
  - `mail_message`: MailMessage, struct del mensaje a enviar por el servidor de correos (requerido)

  ## Examples

      iex> MailUser.send_message(mail_user, mail_message)
      Enviando mensaje a: Nombre Apellido...
      :ok

  """
  def send_message(mail_user, mail_message) do
    mail_message = %{mail_message | from: mail_user.username}
    GenServer.cast(MailServer, {:send_mail, mail_message, mail_message.to})
  end

  def send_message(mail_message) when mail_message.from == nil do
    IO.puts("No se puede enviar un mensaje sin remitente")
  end

  @doc """
  Envía un correo a través del servidor de correos para el destinatario.

  ## Parameters
  - `mail_message`: MailMessage, struct del mensaje a enviar por el servidor de correos (requerido)

  ## Examples

      iex> MailUser.send_message(mail_message)
      Enviando mensaje a: Nombre Apellido...
      :ok

  """
  def send_message(mail_message) do
    GenServer.cast(MailServer, {:send_mail, mail_message, mail_message.to})
  end

  @doc """
  Recibe solicitudes asincronas para recibir un correo del servidor de correos

  ## Parameters

    - `{:new_message, message}`: Tupla que contiene el MailMessage a recibir por el usuario.
    - `state`: El estado actual del GenServer.

  ## Returns

    - `{:noreply, state}`: El resultado del registro del MailUser.

  """
  @impl true
  def handle_cast({:new_message, message}, state) do
    IO.puts("#{state.username} has recibido un mensaje nuevo")
    IO.puts(message)
    {:noreply, state}
  end

end
