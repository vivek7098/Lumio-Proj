@isTest
private class InventoryManagementTest {
    @testSetup
    static void setupTestData() {
        // Create test products
        Product2 product1 = new Product2(Name = 'Test Product 1', Quantity__c = 100);
        insert product1;

        Product2 product2 = new Product2(Name = 'Test Product 2', Quantity__c = 50);
        insert product2;
    }

    @isTest
    static void testReduceInventory() {
        // Fetch the test product
        Product2 product = [SELECT Id, Quantity__c FROM Product2 WHERE Name = 'Test Product 1' LIMIT 1];

        // Reduce inventory
        InventoryManagement.reduceInventory(product.Id, 10);

        // Verify the inventory has been reduced
        Product2 updatedProduct = [SELECT Quantity__c FROM Product2 WHERE Id = :product.Id];
        System.assertEquals(90, updatedProduct.Quantity__c);
    }

    @isTest
    static void testReplenishInventory() {
        // Fetch the test product
        Product2 product = [SELECT Id, Quantity__c FROM Product2 WHERE Name = 'Test Product 1' LIMIT 1];

        // Replenish inventory
        InventoryManagement.replenishInventory(product.Id, 10);

        // Verify the inventory has been replenished
        Product2 updatedProduct = [SELECT Quantity__c FROM Product2 WHERE Id = :product.Id];
        System.assertEquals(110, updatedProduct.Quantity__c);
    }

    @isTest
    static void testReduceInventoryInsufficientStock() {
        // Fetch the test product
        Product2 product = [SELECT Id, Quantity__c FROM Product2 WHERE Name = 'Test Product 2' LIMIT 1];

        // Try to reduce inventory with insufficient stock
        try {
            InventoryManagement.reduceInventory(product.Id, 60);
            System.assert(false, 'Expected InventoryException was not thrown');
        } catch (InventoryManagement.InventoryException ex) {
            System.assertEquals('Insufficient inventory for product: ' + product.Id, ex.getMessage());
        }
    }
}