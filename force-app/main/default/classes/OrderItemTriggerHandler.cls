public class OrderItemTriggerHandler {
    
    public static void handleOrderItemChange(Map<Id, OrderItem> newMap, Map<Id, OrderItem> oldMap) {
        // Set to store order Ids
        Set<Id> orderIds = new Set<Id>();

        // Add order Ids from newMap
        if (newMap != null) {
            for (OrderItem oi : newMap.values()) {
                orderIds.add(oi.OrderId);
            }
        }

        // Add order Ids from oldMap
        if (oldMap != null) {
            for (OrderItem oi : oldMap.values()) {
                orderIds.add(oi.OrderId);
            }
        }

        // Map to store total quantity for each order
        Map<Id, Decimal> orderQuantities = new Map<Id, Decimal>();

        // Query all relevant OrderItems for the orders affected
        List<OrderItem> orderItems = [SELECT OrderId, Quantity FROM OrderItem WHERE OrderId IN :orderIds];

        // Calculate total quantities
        for (OrderItem oi : orderItems) {
            if (!orderQuantities.containsKey(oi.OrderId)) {
                orderQuantities.put(oi.OrderId, 0);
            }
            orderQuantities.put(oi.OrderId, orderQuantities.get(oi.OrderId) + oi.Quantity);
        }

        // Create a list of orders to update
        List<Order> ordersToUpdate = new List<Order>();
        for (Id orderId : orderIds) {
            Decimal totalQuantity = orderQuantities.containsKey(orderId) ? orderQuantities.get(orderId) : 0;
            ordersToUpdate.add(new Order(Id = orderId, Total_Quantity__c = totalQuantity));
        }

        // Update orders
        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }
}