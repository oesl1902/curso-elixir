# MailSystemImproved

Este proyecto contiene el último entregable del curso de programación con Elixir.

## Compilación

Use el siguiente comando para compilar el proyecto
```
iex -S mix
```

## Ejecución

Para iniciar el servidor de correos:

```elixir
MailServer.start_server()
```

Para crear un nuevo usuario y registrarlo en el servidor de correos:
```elixir
user1 = MailUser.new("nombreusuario","Nombre Apellido")
```

Para crear un nuevo mensaje para que pueda ser enviado a través del servidor de correos:
```elixir
message1 = MailMessage.new("usuarioRemitente","usuarioDestinatario","Asunto","Contenido del mensaje")
```

Para enviar un mensaje a través del servidor de correos:
```elixir
MailUser.send_message(message1)
```

Ejemplo:
```elixir
MailServer.start_server()

user1 = MailUser.new("oscar123","Oscar Eduardo Sanchez")
user2 = MailUser.new("santiago123","Santiago Posada")
user3 = MailUser.new("johnd02","John Doe")

message1 = MailMessage.new("oscar123","santiago123","Entregable semana 5","El entregable se encuentra en el github https://github.com/oesl1902/curso-elixir")
MailUser.send_message(message1)

message2 = MailMessage.new("santiago123","oscar123","RE:Entregable semana 5","Entregable recibido")
MailUser.send_message(message2)

message3 = MailMessage.new("johnd02","santiago123","Duda entregable","Hola, dónde puedo encontrar ejemplos")
MailUser.send_message(message3)

message4 = MailMessage.new("santiago123","johnd02","RE:Duda entregable","Hola, en el repo https://github.com/santiagoposadag/Curso_BCB_Elixir_semana5-pt1")
MailUser.send_message(message4)
```

