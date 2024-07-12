defmodule InventoryManager do
  defstruct inventory: [], cart: []

  def add_product(%InventoryManager{inventory: inventory} = inventory_manager, name, price) do
    id = Enum.count(inventory) + 1
    product = %{id: id, name: name, price: price, stock: 0}
    %{inventory_manager | inventory: inventory ++ [product]}
  end

  def list_products(%InventoryManager{inventory: inventory}) do
    IO.puts("Inventario:")
    Enum.each(inventory, fn product ->
      IO.puts("#{product.id}. #{product.name} $#{product.price} Stock:#{product.stock}")
    end)
    IO.puts("")
  end

  def increase_stock(%InventoryManager{inventory: inventory} = inventory_manager, id, quantity) do
    updated_inventory = Enum.map(inventory, fn product ->
      if product.id == id do
        %{product | stock: quantity}
      else
        product
      end
    end)
    %{inventory_manager | inventory: updated_inventory}
  end

  def sell_product(%InventoryManager{inventory: inventory, cart: cart} = inventory_manager, id, quantity) do
    selected_product = Enum.find(inventory, fn product ->
      product.id == id
    end)

    if selected_product.stock >= quantity do
      cart_product = {selected_product.id, quantity}
      updated_cart = cart ++ [cart_product]

      updated_inventory = Enum.map(inventory, fn product ->
        if product.id == id do
          %{product | stock: product.stock - quantity}
        else
          product
        end
      end)

      %{inventory_manager | inventory: updated_inventory, cart: updated_cart}
    else
      IO.puts("Producto sin stock suficiente")
      IO.puts("")
      inventory_manager
    end

  end

  def view_cart(%InventoryManager{inventory: inventory, cart: cart}) do
    IO.puts("Carrito:")
    total = 0
    total = Enum.reduce(cart, 0, fn cart_item, acc ->
      selected_product = Enum.find(inventory, fn product ->
        product.id == elem(cart_item,0)
      end)
      products_price = elem(cart_item,1) * selected_product.price
      IO.puts("#{selected_product.name} x#{elem(cart_item,1)} $#{products_price}")
      products_price + acc
    end)
    IO.puts("Costo Total: $#{total}")
    IO.puts("")
  end

  def checkout(%InventoryManager{inventory: inventory, cart: cart} = inventory_manager) do
    total = Enum.reduce(cart, 0, fn cart_item, acc ->
      selected_product = Enum.find(inventory, fn product ->
        product.id == elem(cart_item,0)
      end)
      products_price = elem(cart_item,1) * selected_product.price
      IO.puts("#{selected_product.name} x#{elem(cart_item,1)} $#{products_price}")
      products_price + acc
    end)
    IO.puts("Total de la Compra: $#{total}")
    IO.puts("¡Muchas gracias vuelva pronto! :D")
    IO.puts("")
    %{inventory_manager | inventory: inventory, cart: []}
  end

  def run do
    inventory_manager = %InventoryManager{}
    loop(inventory_manager)
  end

  defp loop(inventory_manager) do
    IO.puts("""
    Gestor de Inventario
    1. Agregar Producto al Inventario
    2. Listar Productos Inventario
    3. Aumentar Stock de un Producto
    4. Agregar Producto al Carrito
    5. Ver Carrito de Compras
    6. Completar Compra
    7. Salir
    """)

    IO.write("Seleccione una opción: ")
    option = IO.gets("") |> String.trim() |> String.to_integer()

    case option do
      1 ->
        IO.write("Ingrese el nombre del producto: ")
        name = IO.gets("") |> String.trim()
        IO.write("Ingrese el precio del producto: ")
        {price,_} = IO.gets("") |> String.trim() |> Float.parse()
        #task_manager = add_product(task_manager, description)
        inventory_manager = add_product(inventory_manager, name, price)
        loop(inventory_manager)

      2 ->
        list_products(inventory_manager)
        loop(inventory_manager)

      3 ->
        IO.write("Ingrese el ID del producto a actualizar: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad en stock: ")
        quantity = IO.gets("") |> String.trim() |> String.to_integer()
        inventory_manager = increase_stock(inventory_manager, id, quantity)
        loop(inventory_manager)

      4 ->
        IO.write("Ingrese el ID del producto a comprar: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad a comprar: ")
        quantity = IO.gets("") |> String.trim() |> String.to_integer()
        inventory_manager = sell_product(inventory_manager, id, quantity)
        loop(inventory_manager)

      5 ->
        view_cart(inventory_manager)
        loop(inventory_manager)

      6 ->
        inventory_manager = checkout(inventory_manager)
        loop(inventory_manager)

      7 ->
        IO.puts("¡Adiós!")
        :ok

      _ ->
        IO.puts("Opción no válida.")
        loop(inventory_manager)
    end
  end
end

# Ejecutar el gestor de tareas
InventoryManager.run()
