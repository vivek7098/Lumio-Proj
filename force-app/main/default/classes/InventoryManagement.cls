public class InventoryManagement {
    // Method to reduce inventory when an order is placed
    public static void reduceInventory(String productId, Integer quantity) {
        Product2 product = [SELECT Id, Quantity__c FROM Product2 WHERE Id = :productId FOR UPDATE];
        if (product.Quantity__c < quantity) {
            throw new InventoryException('Insufficient inventory for product: ' + productId);
        }
        product.Quantity__c -= quantity;
        update product;
    }

    // Method to replenish inventory when an order is canceled
    public static void replenishInventory(String productId, Integer quantity) {
        Product2 product = [SELECT Id, Quantity__c FROM Product2 WHERE Id = :productId FOR UPDATE];
        product.Quantity__c += quantity;
        update product;
    }

    // Custom exception class for inventory management
    public class InventoryException extends Exception {}
}