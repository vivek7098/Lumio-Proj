trigger OrderItemTrigger on OrderItem (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        OrderItemTriggerHandler.handleOrderItemChange(Trigger.newMap, Trigger.oldMap);
    }
}