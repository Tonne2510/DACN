import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ProductService } from '../../../services/product.service';
import { CategoryService } from '../../../services/category.service';
import { CommonService } from '../../../services/common.service';
@Component({
  selector: 'app-edit-product',
  templateUrl: './edit-product.component.html',
  styleUrl: './edit-product.component.css'
})
export class EditProductComponent implements OnInit {
  productForm: any;
  product: any; 
  categories: any[] = [];
  imagePreview: string | ArrayBuffer | null = null;
  albumPreviews: string[] = []; 
  selectedAlbumFiles: File[] = [];
  editorInstance:any;

  constructor(
    private fb: FormBuilder,
    private categoryService:CategoryService,
    private productService: ProductService,
    private route: ActivatedRoute,
    private commonService:CommonService,
    private Router:Router
  ) {}

  ngOnInit(): void {
    const productId = this.route.snapshot.paramMap.get('id');
    this.initForm();
    this.loadProduct(productId);
    this.loadCategories();

    const CKEDITOR = (window as any)['CKEDITOR']; // Access CKEditor globally
    const descriptionElement = document.getElementById('description');

    if (!descriptionElement) {
      console.error('Element with ID "description" not found.');
      return;
    }

    // Destroy existing instance if already initialized
    if (CKEDITOR.instances['description']) {
      CKEDITOR.instances['description'].destroy(true);
    }

    // Initialize CKEditor
    const editor = CKEDITOR.replace(descriptionElement);
    
    CKEDITOR.instances['description'].setData(this.productForm.description);
    this.editorInstance = editor;
  }



  ngOnDestroy(): void {
    const CKEDITOR = (window as any)['CKEDITOR']; // Access CKEditor globally

    // Destroy CKEditor instance on component destroy
    if (CKEDITOR.instances['description']) {
      CKEDITOR.instances['description'].destroy(true);
    }
  }

  initForm() {
    this.productForm = this.fb.group({
      ProductName: [''],
      Price: [''],
      SalePrice: [''],
      CategoryId: [''],
      Description: [''],
      Active: [''],
    });
  }
  // ngAfterViewInit(): void {
  //   const descriptionElement = document.getElementById('description');
  //   if (descriptionElement && typeof (window as any)['CKEDITOR'] !== 'undefined') {
  //     const editor = (window as any)['CKEDITOR'].replace(descriptionElement);
  //     editor.on('instanceReady', () => {
  //       console.log("CKEditor is ready.");
  
  //       // Lắng nghe sự kiện keyup để cập nhật form khi có thay đổi
  //       editor.on('contentDom', () => {
  //         editor.document.on('keyup', () => {
  //           const data = editor.getData();
  //           console.log("CKEditor Data on keyup:", data);
  //           this.productForm.controls['Description'].setValue(data);
  //         });
  //       });
  
  //       // Thêm sự kiện change để theo dõi bất kỳ thay đổi nào
  //       editor.on('change', () => {
  //         const data = editor.getData();
  //         console.log("CKEditor Data on change:", data);
  //         this.productForm.controls['Description'].setValue(data);
  //       });
  //     });
  //   }
  // }
  
  
  
  loadProduct(id: string | null) {
    if (id) {
      this.productService.getProductById(id).subscribe((product) => {
        this.product = product;
        
        this.productForm.patchValue({
          ProductName: product.productName,
          Price: product.price,
          SalePrice: product.salePrice,
          CategoryId: product.categoryId,
          Description: product.description,
          Active: product.active ? '1' : '0',
        });

        if (typeof product.album === 'string') {
          try {
            product.album = JSON.parse(product.album);
          } catch (error) {
            console.error('Error parsing album:', error);
            product.album = [];
          }
        }
  
        if (Array.isArray(product.album)) {
          this.albumPreviews = product.album.map(image => 'http://localhost:5069/images/' + image);
        } else {
          this.albumPreviews = [];
        }
      });
    }
  }
  
  selectedImage: File | null = null;

  onImageSelect(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.selectedImage = file;
      const reader = new FileReader();
      reader.onload = (e: any) => this.imagePreview = e.target.result;
      reader.readAsDataURL(file);
    }
  }
  
  loadCategories() {
    this.categoryService.searchCategories({ PageNumber: 1, PageSize: 100 }).subscribe(response => {
      this.categories = response.data;
      
    }, error => {
      console.error('Error loading categories', error);
    });
  }

  onAlbumSelect(event: any) {
    const files = event.target.files as FileList;
    this.selectedAlbumFiles = [];
    if (files && files.length) {
        Array.from(files).forEach((file: File) => {
            this.selectedAlbumFiles.push(file);
            const reader = new FileReader();
            reader.onload = (e: any) => this.albumPreviews.push(e.target.result);
            reader.readAsDataURL(file);
        });
    }
}


updateEditorContent() {
  const editor = (window as any)['CKEDITOR'].instances['description']; 
  if (editor) {
    const data = editor.getData();
    console.log("CKEditor Data on submit:", data); 
    this.productForm.controls['Description'].setValue(data);
  }
}

onSubmit() {
  
  this.updateEditorContent();

  if (this.productForm.valid) {
    const formData = new FormData();
    const description = this.editorInstance.getData();
    formData.append('ProductName', this.productForm.get('ProductName')?.value);
    formData.append('Price', this.productForm.get('Price')?.value);
    formData.append('SalePrice', this.productForm.get('SalePrice')?.value);
    formData.append('CategoryId', this.productForm.get('CategoryId')?.value);
    formData.append('Description', description);  
    formData.append('Active', this.productForm.get('Active')?.value);

    if (this.selectedImage) {
      formData.append('Image', this.selectedImage);
    }

    if (this.selectedAlbumFiles.length > 0) {
      this.selectedAlbumFiles.forEach((file: File) => {
        formData.append('Album', file);
      });
    }

    console.log("Form Data before submit:", formData);  

    this.productService.saveProduct(formData, this.product.id).subscribe(response => {
      this.Router.navigate(['/admin/product']);
      this.commonService.showAutoCloseAlert("success","Success","Update product successfully");
    }, error => {
      console.error('Error saving product', error);
    });
  } else {
    this.commonService.showAutoCloseAlert("error","Error","Update product failed");
  }
}
  
}