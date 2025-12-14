import { Component, OnInit } from '@angular/core';
import { RequestApproveService } from '../../../../services/request-approve.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-request-detail',
  templateUrl: './request-detail.component.html',
  styleUrl: './request-detail.component.css'
})
export class RequestDetailComponent implements OnInit{
  comment: any;
  commentId:any;

  constructor(
    private commentService: RequestApproveService,
    private route: ActivatedRoute,
    private router: Router,
  ) {
  
  }
  ngOnInit(): void {
    this.route.paramMap.subscribe(params => {
      this.commentId = params.get('id');
      if (this.commentId) {
        this.loadComment();
      }
    });
  }

  loadComment(): void {
    if (this.commentId) {
      this.commentService.getRequestById(this.commentId).subscribe(
        (comment: any) => {
          console.log('Loaded Comment:', comment);
          this.comment = comment;
        },
        error => {
          console.error('Error loading comment', error);
        }
      );
    }
  }
}
