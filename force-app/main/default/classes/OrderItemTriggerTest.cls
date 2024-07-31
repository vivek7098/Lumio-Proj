@isTest
public class OrderItemTriggerTest {

    @isTest
    static void testAfterInsert() {
        // Create a new Order
        Order testOrder = new Order(
            AccountId = [SELECT Id FROM Account LIMIT 1].Id, 
            EffectiveDate = Date.today()
        );
        insert testOrder;

        // Create OrderItems
        OrderItem item1 = new OrderItem(
            OrderId = testOrder.Id,
            Quantity = 5.5,
            PricebookEntryId = [SELECT Id FROM PricebookEntry LIMIT 1].Id
        );
        OrderItem item2 = new OrderItem(
            OrderId = testOrder.Id,
            Quantity = 10.75,
            PricebookEntryId = [SELECT Id FROM PricebookEntry LIMIT 1].Id
        );
        insert new List<OrderItem>{ item1, item2 };

        // Query the updated Order
        testOrder = [SELECT Total_Quantity__c FROM Order WHERE Id = :testOrder.Id];
        
        // Assert that the Total Quantity is correctly calculated
        System.assertEquals(16.25, testOrder.Total_Quantity__c, 'Total Quantity should be 16.25');
    }

    @isTest
    static void testAfterUpdate() {
        // Create a new Order
        Order testOrder = new Order(
            AccountId = [SELECT Id FROM Account LIMIT 1].Id, 
            EffectiveDate = Date.today()
        );
        insert testOrder;

        // Create OrderItems
        OrderItem item1 = new OrderItem(
            OrderId = testOrder.Id,
            Quantity = 5.5,
            PricebookEntryId = [SELECT Id FROM PricebookEntry LIMIT 1].Id
        );
        insert item1;

        // Update OrderItem
        item1.Quantity = 15.75;
        update item1;

        // Query the updated Order
        testOrder = [SELECT Total_Quantity__c FROM Order WHERE Id = :testOrder.Id];

        // Assert that the Total Quantity is correctly updated
        System.assertEquals(15.75, testOrder.Total_Quantity__c, 'Total Quantity should be 15.75 after update');
    }

    @isTest
    static void testAfterDelete() {
        // Create a new Order
        Order testOrder = new Order(
            AccountId = [SELECT Id FROM Account LIMIT 1].Id, 
            EffectiveDate = Date.today()
        );
        insert testOrder;

        // Create OrderItems
        OrderItem item1 = new OrderItem(
            OrderId = testOrder.Id,
            Quantity = 5.5,
            PricebookEntryId = [SELECT Id FROM PricebookEntry LIMIT 1].Id
        );
        OrderItem item2 = new OrderItem(
            OrderId = testOrder.Id,
            Quantity = 10.75,
            PricebookEntryId = [SELECT Id FROM PricebookEntry LIMIT 1].Id
        );
        insert new List<OrderItem>{ item1, item2 };

        // Delete one OrderItem
        delete item1;

        // Query the updated Order
        testOrder = [SELECT Total_Quantity__c FROM Order WHERE Id = :testOrder.Id];

        // Assert that the Total Quantity is correctly updated after deletion
        System.assertEquals(10.75, testOrder.Total_Quantity__c, 'Total Quantity should be 10.75 after delete');
    }
}