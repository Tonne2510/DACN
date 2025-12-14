import { Component, OnInit } from '@angular/core';
import { OrderService } from '../../../services/order.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-orderdetail',
  templateUrl: './orderdetail.component.html',
  styleUrl: './orderdetail.component.css'
})
export class OrderdetailComponent implements OnInit {
  orderDetail:  any;
  errorMessage: string | null = null;

  constructor(private orderService: OrderService, private route: ActivatedRoute) {}

  ngOnInit(): void {
    const orderId = +this.route.snapshot.paramMap.get('id')!; 

    this.getOrderDetail(orderId);
  }

  private getOrderDetail(orderId: number): void {
    this.orderService.getOrderDetail(orderId).subscribe(
        (data) => {
            this.orderDetail = data;
        },
        (error) => {
            console.error('Error fetching order detail:', error);
            this.errorMessage = 'Could not fetch order details. Please try again later.';
        }
    );
}

}