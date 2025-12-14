import {  NgModule } from '@angular/core';
import { BrowserModule, provideClientHydration } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HeaderComponent } from './components/header/header.component';
import { FooterComponent } from './components/footer/footer.component';
import { HomeComponent } from './components/home/home.component';
import { CategoryComponent } from './components/category/category.component';
import { ProductComponent } from './components/product/product.component';

import { LoginAdminComponent } from './login-admin/login-admin.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { provideHttpClient, withFetch } from '@angular/common/http';
import { AddCategoryComponent } from './components/category/add-category/add-category.component';
import { EditCategoryComponent } from './components/category/edit-category/edit-category.component';
import { AddProductComponent } from './components/product/add-product/add-product.component';
import { EditProductComponent } from './components/product/edit-product/edit-product.component';
import { OptionProductComponent } from './components/option-product/option-product.component';
import { AddOptionProductComponent } from './components/option-product/add-option-product/add-option-product.component';
import { EditOptionProductComponent } from './components/option-product/edit-option-product/edit-option-product.component';
import { AttributeProductComponent } from './components/attribute-product/attribute-product.component';
import { AddAttributeProductComponent } from './components/attribute-product/add-attribute-product/add-attribute-product.component';
import { EditAttributeProductComponent } from './components/attribute-product/edit-attribute-product/edit-attribute-product.component';
import { PostCategoryComponent } from './components/post-category/post-category.component';
import { AddPostCategoryComponent } from './components/post-category/add-category-post/add-category-post.component';
import { EditPostCategoryComponent } from './components/post-category/edit-category-post/edit-category-post.component';
import { ListProductComponent } from './components/product/list-product/list-product.component';
import { DatePipe, CommonModule } from '@angular/common';
import { CommentsComponent } from './components/comments/comments.component';
import { CommentDetailComponent } from './components/comments/comment-detail/comment-detail.component';
import { RequestApproveComponent } from './components/comments/request-approve/request-approve.component';
import { RequestDetailComponent } from './components/comments/request-approve/request-detail/request-detail.component';
import { PostComponent } from './components/post/post.component';
import { AddPostComponent } from './components/post/add-post/add-post.component';
import { EditPostComponent } from './components/post/edit-post/edit-post.component';
import { ListPostComponent } from './components/post/list-post/list-post.component';
import { OrdersComponent } from './components/orders/orders.component';
import { UsersComponent } from './components/users/users.component';
import { ListOrderComponent } from './components/orders/list-order/list-order.component';
import { OrderdetailComponent } from './components/orders/orderdetail/orderdetail.component';
import { MasterviewAdminComponent } from './components/masterview-admin/masterview-admin.component';
import { RouterModule } from '@angular/router';
import { ToastContainerComponent } from './components/shared/toast-container/toast-container.component';



@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    HomeComponent,
    CategoryComponent,
    ProductComponent,
    LoginAdminComponent,
    AddCategoryComponent,
    EditCategoryComponent,
    AddProductComponent,
    EditProductComponent,
    OptionProductComponent,
    AddOptionProductComponent,
    EditOptionProductComponent,
    AttributeProductComponent,
    AddAttributeProductComponent,
    EditAttributeProductComponent,
    PostCategoryComponent,
    AddPostCategoryComponent,
    EditPostCategoryComponent,
    ListProductComponent,
    CommentsComponent,
    CommentDetailComponent,
    RequestApproveComponent,
    RequestDetailComponent,
    PostComponent,
    AddPostComponent,
    EditPostComponent,
    ListPostComponent,
    OrdersComponent,
    UsersComponent,
    ListOrderComponent,
    OrderdetailComponent,
    MasterviewAdminComponent,
    ToastContainerComponent
  ],
  imports: [
    BrowserModule,
    CommonModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule
  ],
  providers: [
    provideClientHydration(),
    provideHttpClient(withFetch()),
    DatePipe
  ],
 
  bootstrap: [AppComponent]
})
export class AppModule { }
