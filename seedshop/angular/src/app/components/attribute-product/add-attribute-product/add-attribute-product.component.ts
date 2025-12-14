import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AttributeService } from '../../../services/attribute.service';
import { AttributeProductComponent } from '../attribute-product.component';
import { CommonService } from '../../../services/common.service';

@Component({
  selector: 'app-add-attribute-product',
  templateUrl: './add-attribute-product.component.html',
  styleUrl: './add-attribute-product.component.css'
})
export class AddAttributeProductComponent {
  addAttributeForm: FormGroup;
  isSubmitting = false;
  
  constructor(
    private fb: FormBuilder, 
    private attributeService: AttributeService, 
    private router: Router,
    private attributeProductComponent: AttributeProductComponent,
    private commonService:CommonService
  ) {
    this.addAttributeForm = this.fb.group({
      attributeCode: ['', [Validators.required]], 
      attributeName: ['', [Validators.required]],
    });
  }
  
  onSubmit(): void {
    if (this.addAttributeForm.valid) {
      const attributeName = this.addAttributeForm.get('attributeName')?.value;
      const attributeCode = this.addAttributeForm.get('attributeCode')?.value;
  
            this.isSubmitting = true;
            const attribute = this.addAttributeForm.value;
  
            this.attributeService.addAttribute(attribute).subscribe(
              response => {
                console.log('Attribute added:', response);
                this.isSubmitting = false;
                this.addAttributeForm.reset();
                this.router.navigate(['/admin/attribute']).then(() => {
                  this.attributeProductComponent.loadAttributes();
                });
                this.commonService.showAutoCloseAlert("success","Success","Attribute product added successfully");
              },
              error => {
                this.commonService.showAutoCloseAlert("error","Error","Attribute name or code has already have");
                this.isSubmitting = false;
              }
            );
          }
        }
}
