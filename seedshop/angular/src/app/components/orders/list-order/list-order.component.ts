import { CommonService } from './../../../services/common.service';
import { CommentService } from './../../../services/comment.service';
import { Component, OnInit } from '@angular/core';
import { OrderService } from '../../../services/order.service';
import { log } from 'node:console';

@Component({
  selector: 'app-list-order',
  templateUrl: './list-order.component.html',
  styleUrl: './list-order.component.css'
})
export class ListOrderComponent implements OnInit {
  orders: any[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';

  Math = Math;

  constructor(private orderService: OrderService, private CommonService:CommonService) {}

  ngOnInit() {
    this.loadOrders();
  }

  loadOrders() {
    const searchParams = {
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: this.statusFilter,
      SortBy: '',
      SortDir: ''
    };

    this.orderService.searchOrders(searchParams).subscribe(response => {
      console.log('Orders response:', response);
      console.log('First order:', response.data[0]);
      this.orders = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading orders', error);
    });
  }

  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadOrders();
    }
  }
  onOrderStatusChange(orderId: number, updatedStatus: string): void {
    console.log('Changing status for order:', orderId, 'to:', updatedStatus);
    this.orderService.changeOrderStatus(orderId, { NewStatus: updatedStatus }).subscribe(
        response => {
            this.CommonService.showAutoCloseAlert("success", "Success", "Order status updated successfully");
            this.loadOrders();
        },
        error => {
            console.error('Error status:', error.status);
            console.error('Error response:', error.error);
            this.CommonService.showAutoCloseAlert("error", "Error", error.error || "Failed to update order status");
        }
    );
}


  
  onSearch() {
    this.currentPage = 1;
    this.loadOrders();
  }
}