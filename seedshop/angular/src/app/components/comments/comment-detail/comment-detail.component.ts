import { Component, OnInit } from '@angular/core';
import { CommentService } from '../../../services/comment.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-comment-detail',
  templateUrl: './comment-detail.component.html',
  styleUrl: './comment-detail.component.css'
})
export class CommentDetailComponent implements OnInit{
  comment: any;
  commentId:any;

  constructor(
    private commentService: CommentService,
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
      this.commentService.getCommentById(this.commentId).subscribe(
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
