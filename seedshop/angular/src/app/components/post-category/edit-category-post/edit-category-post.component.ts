import { CommonService } from './../../../services/common.service';
import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PostCategory } from '../../../interfaces/post-category';
import { PostCategoryService } from '../../../services/post-category.service';
import { PostCategoryComponent } from '../post-category.component';

@Component({
  selector: 'app-edit-category-post',
  templateUrl: './edit-category-post.component.html',
  styleUrls: ['./edit-category-post.component.css']
})
export class EditPostCategoryComponent {
  editPostCategoryForm: FormGroup;
  postCategoryId: any;

  constructor(
    private fb: FormBuilder,
    private postCategoryService: PostCategoryService,
    private route: ActivatedRoute,
    private router: Router,
    private postCategoryComponent: PostCategoryComponent,
    private CommonService:CommonService
  ) {
    this.editPostCategoryForm = this.fb.group({
      postCategoryName: ['', [Validators.required]],
      active: ['1', [Validators.required]]
    });
  }

  ngOnInit(): void {
    this.route.paramMap.subscribe(params => {
      this.postCategoryId = params.get('id');
      if (this.postCategoryId) {
        console.log('PostCategory ID:', this.postCategoryId);
        this.loadPostCategory();
      }
    });
  }

  loadPostCategory(): void {
    if (this.postCategoryId) {
      this.postCategoryService.getPostCategoryById(this.postCategoryId).subscribe(
        (postCategory: PostCategory) => {
          console.log('Loaded PostCategory:', postCategory);
          if (postCategory) {
            this.editPostCategoryForm.patchValue({
              postCategoryName: postCategory.postCategoryName,
              active: +postCategory.active+""
            });
          } else {
            console.error('No post category data found');
          }
          console.log('Form Values after patch:', this.editPostCategoryForm.value);
        },
        error => {
          console.error('Error loading post category', error);
        }
      );
    }
  }

  onSubmit(): void {
    if (this.editPostCategoryForm.valid) {
      const updatedPostCategory: PostCategory = this.editPostCategoryForm.value;
      this.updatePostCategory(updatedPostCategory);
      this.CommonService.showAutoCloseAlert('success',"Success","Edit post category successfully");
    } else {
      console.log('Form is invalid');
    }
  }
  

  private updatePostCategory(updatedPostCategory: PostCategory): void {
    this.postCategoryService.updatePostCategory(this.editPostCategoryForm.value, this.postCategoryId).subscribe(
      response => {
        console.log('PostCategory updated:', response);
        this.router.navigate(['/admin/category-post']).then(() => {
          this.postCategoryComponent.loadPostCategories();
        });
      },
      error => {
        console.error('Error updating post category', error);
      }
    );
  }
}
