@isTest
public class OrderControllerTest {

    @isTest
    static void testGetOrderDetails() {
        // Step 1: Setup test data
        // Create an Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create an Order
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            EffectiveDate = Date.today()
        );
        insert testOrder;

        // Create a Product
        Product2 testProduct = new Product2(Name = 'Test Product', ProductCode = 'SKU123');
        insert testProduct;

        // Create a PricebookEntry
        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = TRUE
        );
        insert testPricebookEntry;

        // Create OrderItems
        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = testPricebookEntry.Id,
            Quantity = 10,
            UnitPrice = 100
        );
        insert testOrderItem;

        // Debug logs to ensure records are created
        System.debug('Test Order ID: ' + testOrder.Id);
        System.debug('Test Order Item ID: ' + testOrderItem.Id);

        // Step 2: Call the method
        Test.startTest();
        OrderController.OrderDetails result = OrderController.getOrderDetails(testOrder.Id);
        Test.stopTest();

        // Debug logs to check results
        System.debug('Result Order: ' + result.order);
        System.debug('Result Order Items: ' + result.orderItems);

        // Step 3: Verify results
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(testOrder.Id, result.order.Id, 'The order ID should match');
        System.assertEquals(testAccount.Name, result.order.Account.Name, 'The account name should match');

        // Verify order items
        System.assertEquals(1, result.orderItems.size(), 'There should be one order item');
        OrderItem item = result.orderItems[0];
        System.assertEquals(testProduct.Name, item.Product2.Name, 'The product name should match');
        System.assertEquals(10, item.Quantity, 'The quantity should match');
        System.assertEquals(100, item.UnitPrice, 'The unit price should match');
    }
}