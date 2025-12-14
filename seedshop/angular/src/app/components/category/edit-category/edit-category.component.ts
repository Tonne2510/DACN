import { CommonService } from './../../../services/common.service';
import { CategoryComponent } from './../category.component';
import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CategoryService } from '../../../services/category.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Category } from '../../../interfaces/category';
import { log } from 'console';

@Component({
  selector: 'app-edit-category',
  templateUrl: './edit-category.component.html',
  styleUrl: './edit-category.component.css'
})
export class EditCategoryComponent {
  editCategoryForm: FormGroup;
  categoryId: any;

  constructor(
    private fb: FormBuilder,
    private categoryService: CategoryService,
    private route: ActivatedRoute,
    private router: Router,
    private categoryComponent:CategoryComponent,
    private CommonService:CommonService
  ) {
    this.editCategoryForm = this.fb.group({
      categoryName: ['', [Validators.required]],
      active: ['', [Validators.required]]
    });
  }
  ngOnInit(): void {
    this.route.paramMap.subscribe(params => {
      this.categoryId = params.get('id');
      if (this.categoryId) {
        console.log('Category ID:', this.categoryId);
        this.loadCategory();
      }
    });
  }

  loadCategory(): void {
    if (this.categoryId) {
      this.categoryService.getCategoryById(this.categoryId).subscribe(
        (category: Category) => {
          console.log('Loaded Category:', category);
          if (category) {
            this.editCategoryForm.patchValue({
              categoryName: category.categoryName,
              active: +category.active+""
            });
          } else {
            console.error('No category data found');
          }
          console.log('Form Values after patch:', this.editCategoryForm.value);
        },
        error => {
          console.error('Error loading category', error);
        }
      );
    }
  }
  
  onSubmit(): void {
    if (this.editCategoryForm.valid) {
      const updatedCategory: Category = this.editCategoryForm.value;
  
      if (this.categoryId) {
        this.categoryService.getCategoryById(this.categoryId).subscribe(
          existingCategory => {
            const isNameChanged = existingCategory.categoryName !== updatedCategory.categoryName;
            const isActiveChanged = existingCategory.active !== updatedCategory.active; 
  
            if (isNameChanged) {
              this.categoryService.checkNameExists(updatedCategory.categoryName).subscribe(
                exists => {
                  if (exists) {
                    this.CommonService.showAutoCloseAlert("warning","Warning","Category name has already exist");
                  } else {
                    this.updateCategory();
                  }
                },
                error => {
                  console.error('Error checking category name', error);
                }
              );
            } else if (isActiveChanged) {
              this.updateCategory();
              this.CommonService.showAutoCloseAlert("success","Success","Edit category successfully");
            } else {
              alert('No changes detected. The category will not be updated.');
            }
          },
          error => {
            console.error('Error fetching category', error);
          }
        );
      }
    }
  }
  
  
  private updateCategory(): void {
    console.log(this.editCategoryForm.value);
    
    this.categoryService.updateCategory(this.editCategoryForm.value, this.categoryId).subscribe(
      response => {
        console.log('Category updated:', response);
        this.router.navigate(['/admin/category']).then(() => {
          this.categoryComponent.loadCategories();
        });
      },
      error => {
        this.CommonService.showAutoCloseAlert("error","Error","Edit category faileds");
      }
    );
  }
}  