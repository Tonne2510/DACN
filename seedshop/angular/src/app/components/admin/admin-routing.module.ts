
import { EditOptionProductComponent } from './../option-product/edit-option-product/edit-option-product.component';
import { Component, NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MasterviewAdminComponent } from '../masterview-admin/masterview-admin.component';
import { CategoryComponent } from '../category/category.component';
import { ProductComponent } from '../product/product.component';
import { HomeComponent } from '../home/home.component';
import { AddCategoryComponent } from '../category/add-category/add-category.component';
import { EditCategoryComponent } from '../category/edit-category/edit-category.component';
import { AttributeProductComponent } from '../attribute-product/attribute-product.component';
import { AddAttributeProductComponent } from '../attribute-product/add-attribute-product/add-attribute-product.component';
import { EditAttributeProductComponent } from '../attribute-product/edit-attribute-product/edit-attribute-product.component';
import { OptionProductComponent } from '../option-product/option-product.component';
import { AddOptionProductComponent } from '../option-product/add-option-product/add-option-product.component';
import { PostCategoryComponent } from '../post-category/post-category.component';
import { AddPostCategoryComponent } from '../post-category/add-category-post/add-category-post.component';
import { EditPostCategoryComponent } from '../post-category/edit-category-post/edit-category-post.component';
import { ListProductComponent } from '../product/list-product/list-product.component';
import { AddProductComponent } from '../product/add-product/add-product.component';
import { EditProductComponent } from '../product/edit-product/edit-product.component';
import { CommentsComponent } from '../comments/comments.component';
import { CommentDetailComponent } from '../comments/comment-detail/comment-detail.component';
import { RequestApproveComponent } from '../comments/request-approve/request-approve.component';
import { RequestDetailComponent } from '../comments/request-approve/request-detail/request-detail.component';
import { PostComponent } from '../post/post.component';
import { ListPostComponent } from '../post/list-post/list-post.component';
import { AddPostComponent } from '../post/add-post/add-post.component';
import { EditPostComponent } from '../post/edit-post/edit-post.component';
import { OrdersComponent } from '../orders/orders.component';
import path from 'path';
import { ListOrderComponent } from '../orders/list-order/list-order.component';
import { OrderdetailComponent } from '../orders/orderdetail/orderdetail.component';

const routes: Routes = [
  { path: '', component: MasterviewAdminComponent, children: [
    { path: '', component: HomeComponent},
    { path: 'category', component: CategoryComponent, children: [
      { path: '', component: AddCategoryComponent},
      { path: 'edit/:id', component: EditCategoryComponent }
    ]},
    { path: 'product', component: ProductComponent, children: [
      { path: '', component:ListProductComponent},
      { path: 'add', component: AddProductComponent},
      { path: 'edit/:id', component: EditProductComponent}
    ]},
    { path: 'attribute', component:AttributeProductComponent, children: [
      { path: '', component:AddAttributeProductComponent},
      { path: 'edit/:id', component: EditAttributeProductComponent }
    ]},
    { path: 'option', component:OptionProductComponent, children: [
      { path: '', component:AddOptionProductComponent},
      { path: 'edit/:id', component: EditOptionProductComponent }
    ]},
    { path: 'category-post', component:PostCategoryComponent, children: [
      { path: '', component:AddPostCategoryComponent },
      { path: 'edit/:id', component:EditPostCategoryComponent }
    ]},
    { path: 'comment', component:CommentsComponent, children: [
      
    ]},
    { path: 'comment/detail/:id', component:CommentDetailComponent },
    { path: 'request-approve', component:RequestApproveComponent },
    { path: 'request-approve/detail/:id', component:RequestDetailComponent },
    {
      path: 'post', component: PostComponent, children: [
        { path: '', component: ListPostComponent },
        { path: 'add', component: AddPostComponent },
        { path: 'edit/:id', component: EditPostComponent }
      ]
    },
    { path: 'orders', component:OrdersComponent, children: [
      { path:'', component: ListOrderComponent },
      { path: "order-detail/:id", component:OrderdetailComponent}
    ]}
  ]},
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule { }
