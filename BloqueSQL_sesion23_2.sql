-- Consulta 1: Clientes de Santiago​
db.clientes.find(​
  { "Ciudad": "Santiago" },​
  { "Nombre": 1, "Ciudad": 1, "_id": 0 }​
);​

-- Resultado esperado:​

-- { "Nombre": "Juan Pérez", "Ciudad": "Santiago" }​
-- { "Nombre": "Ana López", "Ciudad": "Santiago" }​
-- Consulta 2: Número total de productos vendidos por producto​
db.clientes.aggregate([​
  { $unwind: "$Pedidos" },​
  { $unwind: "$Pedidos.Detalles" },​
  {​
	$group: {​
  	_id: "$Pedidos.Detalles.Nombre",​
  	TotalVendidos: { $sum: "$Pedidos.Detalles.Cantidad" }​
	}​
  }​
]);​
-- Resultado esperado:​
-- { "_id": "Laptop", "TotalVendidos": 3 }​
-- { "_id": "Mouse", "TotalVendidos": 7 }