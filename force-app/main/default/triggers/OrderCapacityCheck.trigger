trigger OrderCapacityCheck on Order (before insert, before update) {
    for (Order ord : Trigger.new) {
        // Ensure you replace `Total_Quantity__c` with the actual field on the Order object
        Integer orderQuantity = Integer.valueOf(ord.Total_Quantity__c);
        
        try {
            String message = ProductionCapacityService.checkProductionCapacity(orderQuantity);
            
            if (ProductionCapacityService.isCapacityExceeded(orderQuantity)) {
                ord.addError(message);
            }
        } catch (ProductionCapacityService.CustomException e) {
            ord.addError(e.getMessage());
        }
    }
}