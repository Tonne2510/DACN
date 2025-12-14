import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { AttributeOptionService } from '../../../services/attribute-option.service';
import { AttributeService } from '../../../services/attribute.service';
import { OptionProductComponent } from '../option-product.component';

@Component({
  selector: 'app-edit-option-product',
  templateUrl: './edit-option-product.component.html',
  styleUrl: './edit-option-product.component.css'
})
export class EditOptionProductComponent implements OnInit {
  editOptionForm: FormGroup;
  optionId: any;
  attributes: any[] = [];

  constructor(
    private fb: FormBuilder,
    private attributeService: AttributeService,
    private attributeOptionService: AttributeOptionService,
    private route: ActivatedRoute,
    private router: Router,
    private optionProductComponent: OptionProductComponent
  ) {
    this.editOptionForm = this.fb.group({
      optionName: ['', [Validators.required]],
      attributeId: ['', [Validators.required]]
    });
  }

  ngOnInit(): void {
    this.loadAttributes();
    this.route.paramMap.subscribe(params => {
      this.optionId = params.get('id');
      if (this.optionId) {
        this.loadOption();
      }
    });
  }

  loadAttributes(): void {
    this.attributeService.searchAttributes({ PageNumber: 1, PageSize: 100 }).subscribe(
      response => {
        this.attributes = response.data;
      },
      error => {
        console.error('Error loading attributes', error);
      }
    );
  }

  loadOption(): void {
    if (this.optionId) {
      this.attributeOptionService.getAttributeOptionById(this.optionId).subscribe(
        (option: any) => {
          if (option) {
            this.editOptionForm.patchValue({
              optionName: option.optionName,
              attributeId: option.attributeId
            });
          } else {
            console.error('No option data found');
          }
        },
        error => {
          console.error('Error loading option', error);
        }
      );
    }
  }

  onSubmit(): void {
    if (this.editOptionForm.valid) {
      this.updateOption();
    }
  }

  private updateOption(): void {
    this.attributeOptionService.updateAttributeOption(this.editOptionForm.value, this.optionId).subscribe(
      response => {
        console.log('Option updated:', response);
        this.router.navigate(['/admin/option']).then(() => {
          this.optionProductComponent.loadOptions(); // Reload the list after updating
        });
      },
      error => {
        console.error('Error updating option', error);
      }
    );
  }
}