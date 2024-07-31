import { LightningElement, api, wire } from 'lwc';
import getOrderSummary from '@salesforce/apex/OrderController.getOrderSummary';

export default class OrderSummary extends LightningElement {
    @api recordId;
    orderSummary;
    error;

    columns = [
        { label: 'Product Name', fieldName: 'productName' },
        { label: 'Quantity', fieldName: 'Quantity', type: 'number' },
        { label: 'Price', fieldName: 'UnitPrice', type: 'currency' }
    ];

    @wire(getOrderSummary, { orderId: '$recordId' })
    wiredOrder({ error, data }) {
        if (data) {
            this.orderSummary = {
                orderNumber: data.orderNumber,
                customerName: data.customerName,
                totalQuantity: data.totalQuantity,
                orderItems: data.orderItems.map(item => ({
                    Id: item.Id,
                    productName: item.PricebookEntry.Product2.Name,
                    Quantity: item.Quantity,
                    UnitPrice: item.UnitPrice
                }))
            };
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.orderSummary = undefined;
        }
    }
}