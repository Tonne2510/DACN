import { CommonService } from './../../../services/common.service';
import { OptionProductComponent } from './../option-product.component';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { AttributeOptionService } from '../../../services/attribute-option.service';
import { AttributeService } from '../../../services/attribute.service';
import { Router } from '@angular/router';
import { CommonOptions } from 'child_process';

@Component({
  selector: 'app-add-option-product',
  templateUrl: './add-option-product.component.html',
  styleUrl: './add-option-product.component.css'
})
export class AddOptionProductComponent implements OnInit {
  addOptionForm: FormGroup;
  attributes: any[] = [];

  constructor(
    private fb: FormBuilder,
    private attributeService: AttributeService,
    private attributeOptionService: AttributeOptionService,
    private optionProductComponent:OptionProductComponent,
    private router: Router,
    private CommonService:CommonService
  ) {
    this.addOptionForm = this.fb.group({
      optionName: ['', Validators.required],
      attributeId: ['', Validators.required] 
    });
  }

  ngOnInit(): void {
    this.loadAttributes();
  }

  loadAttributes(): void {
    this.attributeService.searchAttributes({ PageNumber: 1, PageSize: 100 })
      .subscribe(
        (response) => {
          this.attributes = response.data;
        },
        (error) => {
          console.error('Error loading attributes:', error);
        }
      );
  }

  onSubmit(): void {
    if (this.addOptionForm.valid) {
      const newOption = this.addOptionForm.value;

      this.attributeOptionService.addAttributeOption(newOption).subscribe(
        (response) => {
          this.CommonService.showAutoCloseAlert('success',"Success","Add option product successfully");
          this.router.navigate(['/admin/option']).then(() => {
            this.optionProductComponent.loadOptions();
          });
        },
        (error) => {
          this.CommonService.showAutoCloseAlert("error","Error","Name has already exist");
        }
      );
    }
  }
}