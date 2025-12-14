import { CommonService } from './../../services/common.service';
import { Component } from '@angular/core';
import { AttributeOptionService } from '../../services/attribute-option.service';

@Component({
  selector: 'app-option-product',
  templateUrl: './option-product.component.html',
  styleUrl: './option-product.component.css'
})
export class OptionProductComponent {
  options: any[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';

  Math = Math;

  constructor(private attributeOptionService: AttributeOptionService, private CommonService:CommonService) {}

  ngOnInit() {
    this.loadOptions();
  }

  loadOptions() {
    const searchParams = {
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: this.statusFilter,
      SortBy: '',
      SortDir: ''
    };

    this.attributeOptionService.searchAttributeOptions(searchParams).subscribe(response => {
      this.options = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading options', error);
    });
  }

  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadOptions();
    }
  }

  onSearch() {
    this.currentPage = 1;
    this.loadOptions();
  }

  async deleteOption(id: number): Promise<void> {
    if (
      await this.CommonService.showConfirmation("warning", "Warning", "Oke", "Cancel")
    ) {
      this.attributeOptionService.deleteAttributeOption(id).subscribe(
        response => {
          this.CommonService.showAutoCloseAlert("success","Success","Attribute option deleted");
          this.loadOptions();
        },
        error => {
          console.error('Error deleting option:', error);
        }
      );
    }
  }
}
