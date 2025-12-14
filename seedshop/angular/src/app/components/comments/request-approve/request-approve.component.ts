import { CommonService } from './../../../services/common.service';
import { Component } from '@angular/core';
import { CommentService } from '../../../services/comment.service';
import { DatePipe } from '@angular/common';
import { SearchCommentParams } from '../../../services/search-post-params';
import { RequestApproveService } from '../../../services/request-approve.service';

@Component({
  selector: 'app-request-approve',
  templateUrl: './request-approve.component.html',
  styleUrl: './request-approve.component.css'
})
export class RequestApproveComponent {
  comments: any[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';
  startDate = '';
  endDate = '';
  IsActive = '';

  Math = Math;

  constructor(private requestService: RequestApproveService, private datePipe: DatePipe, private CommonService:CommonService) {}

  ngOnInit() {
    this.loadRequests();
  }

  loadRequests() {
    var startDate1 ='';
    var endDate1 = '';
    if(this.startDate!=''){
      
       startDate1 = this.datePipe.transform(this.startDate, 'dd/MM/yyyy') || '';
    }
    if(this.endDate!=''){
      endDate1 = this.datePipe.transform(this.endDate, 'dd/MM/yyyy') || '';

    }
    const searchParams: SearchCommentParams = {
      pageNumber: this.currentPage,
      pageSize: this.pageSize,
      keyword: '',
      status: '',
      sortBy: '',
      sortDir: '',
      startDate: startDate1,
      endDate: endDate1,
      isActive:''
    };
  
    this.requestService.searchRequestComment(searchParams).subscribe(response => {
      console.log(response)
      this.comments = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading request comment', error);
    });
  }
  
  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadRequests();
    }
  }

  onSearch() {
    this.currentPage = 1;
    this.loadRequests();
  }

  async approveRequestComment(id: number): Promise<void> {
    if (
      await this.CommonService.showConfirmation("warning", "Warning", "Oke", "Cancel")
    ) {
      this.requestService.approveRequest(id).subscribe(
        response => {
          this.loadRequests();
          this.CommonService.showAutoCloseAlert("success","Success","Approved Comment");
        },
        error => {
          console.error('Error approving comment:', error);
        }
      );
    }
  }

  async rejectRequestComment(id: number): Promise<void> {
    if (
      await this.CommonService.showConfirmation("warning", "Warning", "Ok", "Cancel")
    ) {
      this.requestService.rejectRequest(id).subscribe(
        response => {
          this.loadRequests();
          this.CommonService.showAutoCloseAlert("success","Success","Reject comment successfully");
        },
        error => {
          console.error('Error rejected comment:', error);
        }
      );
    }
  }
}
