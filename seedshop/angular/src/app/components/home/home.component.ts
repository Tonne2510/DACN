import { Component, OnInit } from '@angular/core';
import { AccountService } from '../../services/account.service';
import { ProductService } from '../../services/product.service';
import { OrderService } from '../../services/order.service';
import { SearchParams } from '../../services/search-params';
import { SearchPostParams } from '../../services/search-post-params';

declare var Chart: any;

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  totalUsers: number = 0;
  totalProducts: number = 0;
  totalOrders: number = 0;
  totalRevenue: number = 0;
  loading: boolean = true;
  
  // Chart data
  revenueChart: any;
  orderStatusChart: any;
  monthlyData: any[] = [];

  constructor(
    private accountService: AccountService,
    private productService: ProductService,
    private orderService: OrderService
  ) {}

  ngOnInit(): void {
    this.loadDashboardData();
  }

  loadDashboardData(): void {
    this.loading = true;
    
    // Load total users
    const userParams: SearchPostParams = {
      PageNumber: 1,
      PageSize: 1,
      Keyword: '',
      Status: '',
      SortBy: 'CreatedAt',
      SortDir: 'desc'
    };
    
    this.accountService.searchPosts(userParams).subscribe({
      next: (response) => {
        this.totalUsers = response.totalRecords || 0;
      },
      error: (err) => console.error('Error loading users:', err)
    });

    // Load total products
    const productParams: SearchParams = {
      pageNumber: 1,
      pageSize: 1,
      keyword: '',
      status: '',
      sortBy: 'CreatedAt',
      sortDir: 'desc',
      toPrice: 0,
      fromPrice: 0,
      categoryId: null,
      optionIds: []
    };
    
    this.productService.searchProducts(productParams).subscribe({
      next: (response) => {
        this.totalProducts = response.totalRecords || 0;
      },
      error: (err) => console.error('Error loading products:', err)
    });

    // Load orders and calculate revenue
    const orderParams: any = {
      pageNumber: 1,
      pageSize: 999999,
      keyword: '',
      status: '',
      sortBy: 'CreatedAt',
      sortDir: 'desc'
    };
    
    this.orderService.searchOrders(orderParams).subscribe({
      next: (response) => {
        this.totalOrders = response.totalRecords || 0;
        
        // Calculate total revenue and prepare chart data
        if (response.data && Array.isArray(response.data)) {
          this.totalRevenue = response.data.reduce((sum: number, order: any) => {
            return sum + (order.totalPrice || order.totalAmount || 0);
          }, 0);
          
          // Prepare monthly data for charts
          this.prepareChartData(response.data);
        }
        
        this.loading = false;
        
        // Initialize charts after data is loaded
        setTimeout(() => {
          this.initCharts();
        }, 100);
      },
      error: (err) => {
        console.error('Error loading orders:', err);
        this.loading = false;
      }
    });
  }

  prepareChartData(orders: any[]): void {
    // Group orders by month
    const monthlyRevenue: { [key: string]: number } = {};
    const monthlyOrders: { [key: string]: number } = {};
    const statusCount: { [key: string]: number } = {
      'Ordered': 0,
      'Shipping': 0,
      'Delivered': 0,
      'Cancelled': 0
    };

    orders.forEach(order => {
      // Monthly revenue
      const date = new Date(order.orderDate || order.createdAt);
      const monthKey = `${date.getMonth() + 1}/${date.getFullYear()}`;
      
      monthlyRevenue[monthKey] = (monthlyRevenue[monthKey] || 0) + (order.totalPrice || order.totalAmount || 0);
      monthlyOrders[monthKey] = (monthlyOrders[monthKey] || 0) + 1;
      
      // Status count
      const status = order.status || 'Ordered';
      if (statusCount.hasOwnProperty(status)) {
        statusCount[status]++;
      }
    });

    // Convert to array for charts (last 6 months)
    const months = Object.keys(monthlyRevenue).sort().slice(-6);
    this.monthlyData = months.map(month => ({
      month,
      revenue: monthlyRevenue[month],
      orders: monthlyOrders[month]
    }));

    // Store status data
    (this as any).statusData = statusCount;
  }

  initCharts(): void {
    this.initRevenueChart();
    this.initOrderStatusChart();
  }

  initRevenueChart(): void {
    const ctx = document.getElementById('revenueChart') as HTMLCanvasElement;
    if (!ctx) {
      console.log('Canvas revenueChart not found');
      return;
    }

    if (this.monthlyData.length === 0) {
      console.log('No monthly data available');
      return;
    }

    const labels = this.monthlyData.map(d => d.month);
    const data = this.monthlyData.map(d => d.revenue);

    console.log('Creating revenue chart with data:', { labels, data });

    // Determine max value for auto-scaling
    const maxValue = Math.max(...data);
    let divisor = 1;
    let suffix = '';
    
    if (maxValue >= 1000000000) {
      divisor = 1000000000;
      suffix = 'B';
    } else if (maxValue >= 1000000) {
      divisor = 1000000;
      suffix = 'M';
    } else if (maxValue >= 1000) {
      divisor = 1000;
      suffix = 'K';
    }

    this.revenueChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Doanh thu (VNĐ)',
          data: data,
          borderColor: '#5a9a3a',
          backgroundColor: 'rgba(90, 154, 58, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          tooltip: {
            callbacks: {
              label: (context: any) => {
                return 'Doanh thu: ' + this.formatCurrency(context.parsed.y);
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: (value: any) => {
                if (divisor === 1) {
                  return value.toLocaleString('vi-VN');
                }
                return (value / divisor).toFixed(1) + suffix;
              }
            }
          }
        }
      }
    });
  }

  initOrderStatusChart(): void {
    const ctx = document.getElementById('orderStatusChart') as HTMLCanvasElement;
    if (!ctx) {
      console.log('Canvas orderStatusChart not found');
      return;
    }

    const statusData = (this as any).statusData || {};
    const labels = Object.keys(statusData);
    const data = Object.values(statusData);

    console.log('Creating status chart with data:', { labels, data });

    if (labels.length === 0) {
      console.log('No status data available');
      return;
    }

    this.orderStatusChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: labels.map(status => {
          const translations: any = {
            'Ordered': 'Đã đặt',
            'Shipping': 'Đang giao',
            'Delivered': 'Đã giao',
            'Cancelled': 'Đã hủy'
          };
          return translations[status] || status;
        }),
        datasets: [{
          data: data,
          backgroundColor: [
            '#5a9a3a',
            '#48abf7',
            '#31ce36',
            '#f25961'
          ],
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'bottom'
          }
        }
      }
    });
  }

  formatCurrency(amount: number): string {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  }
}
