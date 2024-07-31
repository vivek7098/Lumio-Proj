public class ProductionCapacityService {
    
    // Method to get the current production capacity from custom metadata
    public static Integer getProductionCapacity() {
        List<Production_Capacity__mdt> capacityRecords = [SELECT Capacity__c FROM Production_Capacity__mdt LIMIT 1];
        
        // Check if any records are returned
        if (!capacityRecords.isEmpty()) {
            return Integer.valueOf(capacityRecords[0].Capacity__c);
        } else {
            throw new CustomException('No production capacity record found.');
        }
    }

    // Method to check if the order quantity exceeds the production capacity
    public static Boolean isCapacityExceeded(Integer orderQuantity) {
        Integer productionCapacity = getProductionCapacity();
        return orderQuantity > productionCapacity;
    }

    // Method to return an appropriate message if capacity is exceeded
    public static String checkProductionCapacity(Integer orderQuantity) {
        if (isCapacityExceeded(orderQuantity)) {
            return 'Order quantity exceeds available production capacity.';
        } else {
            return 'Order quantity is within the production capacity.';
        }
    }

    // Custom exception for handling errors
    public class CustomException extends Exception {}
}