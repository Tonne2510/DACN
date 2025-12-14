import { CommonService } from './../../../services/common.service';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { AttributeService } from '../../../services/attribute.service';
import { AttributeProductComponent } from '../attribute-product.component';
import { Router } from '@angular/router';
@Component({
  selector: 'app-edit-attribute-product',
  templateUrl: './edit-attribute-product.component.html',
  styleUrl: './edit-attribute-product.component.css'
})
export class EditAttributeProductComponent implements OnInit {
  editAttributeForm: FormGroup;
  attributeId: any;

  constructor(
    private fb: FormBuilder,
    private attributeService: AttributeService,
    private route: ActivatedRoute,
    private router: Router,
    private attributeProductComponent: AttributeProductComponent,
    private CommonService:CommonService
  ) {
    this.editAttributeForm = this.fb.group({
      attributeCode: ['', [Validators.required]],
      attributeName: ['', [Validators.required]]
    });
  }

  ngOnInit(): void {
    this.route.paramMap.subscribe(params => {
      this.attributeId = params.get('id');
      if (this.attributeId) {
        console.log('Attribute ID:', this.attributeId);
        this.loadAttribute();
      }
    });
  }

  loadAttribute(): void {
    if (this.attributeId) {
      this.attributeService.getAttributeById(this.attributeId).subscribe(
        (attribute: any) => {
          console.log('Loaded Attribute:', attribute);
          if (attribute) {
            this.editAttributeForm.patchValue({
              attributeCode: attribute.attributeCode,
              attributeName: attribute.attributeName
            });
          } else {
            console.error('No attribute data found');
          }
          console.log('Form Values after patch:', this.editAttributeForm.value);
        },
        error => {
          console.error('Error loading attribute', error);
        }
      );
    }
  }

  onSubmit(): void {
    if (this.editAttributeForm.valid) {
      this.updateAttribute();
    }
  }
  

  private updateAttribute(): void {
    this.attributeService.updateAttribute(this.editAttributeForm.value, this.attributeId).subscribe(
      response => {
        console.log('Attribute updated:', response);
        this.router.navigate(['/admin/attribute']).then(() => {
          this.attributeProductComponent.loadAttributes();
        });
        this.CommonService.showAutoCloseAlert("success", "Success", "Edit attribute successfully");
      },
      error => {
        this.CommonService.showAutoCloseAlert("error", "Error", "Edit attribute failed");
      }
    );
  }
}
