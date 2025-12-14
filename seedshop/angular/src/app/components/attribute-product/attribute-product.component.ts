import { Component } from '@angular/core';
import { AttributeService } from '../../services/attribute.service';
import { CommonService } from '../../services/common.service';

@Component({
  selector: 'app-attribute-product',
  templateUrl: './attribute-product.component.html',
  styleUrl: './attribute-product.component.css'
})
export class AttributeProductComponent {
  attributes: any[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';

  Math = Math;

  constructor(private attributeService: AttributeService, private commonService:CommonService) {}

  ngOnInit() {
    this.loadAttributes();
  }

  loadAttributes() {
    const searchParams = {
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: this.statusFilter,
      SortBy: '',
      SortDir: ''
    };

    this.attributeService.searchAttributes(searchParams).subscribe(response => {
      this.attributes = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading attributes', error);
    });
  }

  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadAttributes();
    }
  }

  onSearch() {
    this.currentPage = 1;
    this.loadAttributes();
  }

  async deleteAttribute(id: number): Promise<void> {
    if (
      await this.commonService.showConfirmation("Warning", "Are you sure to countinue?", "Oke", "Cancel")
    ) {
      this.attributeService.deleteAttribute(id).subscribe(
        response => {
          this.loadAttributes();
          this.commonService.showAutoCloseAlert("success","Success", "Delete attribute successfuly");
        },
        error => {
          console.error('Error deleting attribute:', error);
        }
      );
    }
  }
}