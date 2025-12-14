import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CategoryService } from './../../../services/category.service';
import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CategoryComponent } from '../category.component';
import { CommonService } from '../../../services/common.service';
@Component({
  selector: 'app-add-category',
  templateUrl: './add-category.component.html',
  styleUrl: './add-category.component.css'
})
export class AddCategoryComponent {
  addCategoryForm: FormGroup;
  isSubmitting = false;
  
  constructor(
    private fb: FormBuilder, 
    private categoryService: CategoryService, 
    private router: Router,
    private categoryComponent:CategoryComponent,
    private commonService:CommonService
  ) {
    this.addCategoryForm = this.fb.group({
      categoryName: ['', [Validators.required]],
      active: ['1', [Validators.required]],
    });
  }
  
  onSubmit(): void {
    if (this.addCategoryForm.valid) {
      const categoryName = this.addCategoryForm.get('categoryName')?.value;

      this.categoryService.checkNameExists(categoryName).subscribe(
        exists => {
          if (exists) {
              this.commonService.showAlert("warning","Warning", "Category name already exists. Please choose a different name.")
            this.isSubmitting = false;
          } else {
            this.isSubmitting = true;
            const category = this.addCategoryForm.value;

            this.categoryService.addCategory(category).subscribe(
              response => {
                console.log('Category added:', response);
                this.isSubmitting = false;
                this.addCategoryForm.reset();
                this.addCategoryForm.patchValue({ active: '1' });
                this.router.navigate(['/admin/category']).then(() => {
                  this.categoryComponent.loadCategories();
                });
                this.commonService.showAutoCloseAlert("success", "Success", "Add category successfully");
              },
              error => {
                console.error('Error adding category:', error);
                this.isSubmitting = false;
              }
            );
          }
        },
        error => {
          console.error('Error checking category name:', error);
          this.isSubmitting = false;
        }
      );
    }
  }
  
}
