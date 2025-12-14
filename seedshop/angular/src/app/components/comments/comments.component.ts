import { CommonService } from './../../services/common.service';
import { Component, OnInit } from '@angular/core';
import { CommentService } from '../../services/comment.service';
import { SearchCommentParams } from '../../services/search-post-params';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-comments',
  templateUrl: './comments.component.html',
  styleUrl: './comments.component.css'
})
export class CommentsComponent implements OnInit{
  comments: any[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';
  startDate = '';
  endDate = '';
  IsActive = 'APPROVED';

  Math = Math;

  constructor(private commentService: CommentService, private datePipe: DatePipe, private CommonService:CommonService) {}

  ngOnInit() {
    this.loadComments();
  }

  loadComments() {
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
      keyword: this.searchKeyword,
      status: '',
      sortBy: '',
      sortDir: '',
      startDate: startDate1,
      endDate: endDate1,
      isActive:this.statusFilter || this.IsActive
    };
  
    this.commentService.searchComment(searchParams).subscribe(response => {
      console.log(response)
      this.comments = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading comments', error);
    });
  }
  
  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadComments();
    }
  }

  onSearch() {
    this.currentPage = 1;
    this.loadComments();
  }

  async deleteComment(id: number): Promise<void> {
    if (
      await this.CommonService.showConfirmation("warning", "Are you sure to continue?", "Oke", "Cancel")
    ) {
      this.commentService.deleteComment(id).subscribe(
        response => {
          console.log('Comment deleted:', response);
          this.loadComments();
          this.CommonService.showAutoCloseAlert("success","Success","Delete product Successfully");
        },
        error => {
          console.error('Error deleting comment:', error);
        }
      );
    }
  }
}
