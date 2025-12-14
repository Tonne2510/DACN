import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { PostCategoryService } from '../../../services/post-category.service';
import { PostCategoryComponent } from '../post-category.component';
import { Router } from '@angular/router';

@Component({
  selector: 'app-add-category-post',
  templateUrl: './add-category-post.component.html',
  styleUrl: './add-category-post.component.css'
})
export class AddPostCategoryComponent {
  addPostCategoryForm: FormGroup;
  isSubmitting = false;

  constructor(
    private fb: FormBuilder, 
    private postCategoryService: PostCategoryService, 
    private router: Router,
    private postCategoryComponent: PostCategoryComponent
  ) {
    this.addPostCategoryForm = this.fb.group({
      postCategoryName: ['', [Validators.required]],
      active: ['1', [Validators.required]],
    });
  }

  onSubmit(): void {
    if (this.addPostCategoryForm.valid) {

            const postCategory = this.addPostCategoryForm.value;

            this.postCategoryService.addPostCategory(postCategory).subscribe(
              response => {
                console.log('Post Category added:', response);
                this.isSubmitting = false;
                this.addPostCategoryForm.reset();
                this.addPostCategoryForm.patchValue({ active: '1' });
                this.router.navigate(['/admin/category-post']).then(() => {
                  this.postCategoryComponent.loadPostCategories(); 
                });
              },
              error => {
                alert("post category đã có");
                console.error('Error adding post category:', error);
                this.isSubmitting = false;
              }
            );
      
    }
  }
}