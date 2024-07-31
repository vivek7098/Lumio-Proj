public with sharing class OrderController {
    @AuraEnabled(cacheable=true)
    public static OrderSummary getOrderSummary(Id orderId) {
        Order order = [
            SELECT Id, OrderNumber, Account.Name, 
                   (SELECT Quantity, UnitPrice, PricebookEntry.Product2.Name FROM OrderItems) 
            FROM Order 
            WHERE Id = :orderId 
            LIMIT 1
        ];
        
        Integer totalQuantity = 0;
        for (OrderItem item : order.OrderItems) {
            totalQuantity += Integer.valueOf(item.Quantity);
        }

        OrderSummary summary = new OrderSummary();
        summary.orderNumber = order.OrderNumber;
        summary.customerName = order.Account.Name;
        summary.totalQuantity = totalQuantity;
        summary.orderItems = order.OrderItems;

        return summary;
    }

    public class OrderSummary {
        @AuraEnabled
        public String orderNumber;
        @AuraEnabled
        public String customerName;
        @AuraEnabled
        public Integer totalQuantity;
        @AuraEnabled
        public List<OrderItem> orderItems;
    }
}