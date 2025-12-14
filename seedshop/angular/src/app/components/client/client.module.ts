import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { ClientRoutingModule } from './client-routing.module';
import { ClientHeaderComponent } from './layout/client-header/client-header.component';
import { ClientFooterComponent } from './layout/client-footer/client-footer.component';
import { ClientHomeComponent } from './pages/client-home/client-home.component';
import { ProductsListComponent } from './pages/products-list/products-list.component';
import { ProductDetailComponent } from './pages/product-detail/product-detail.component';
import { CartPageComponent } from './pages/cart-page/cart-page.component';
import { CheckoutComponent } from './pages/checkout/checkout.component';
import { UserOrdersComponent } from './pages/user-orders/user-orders.component';
import { BlogListComponent } from './pages/blog-list/blog-list.component';
import { BlogDetailComponent } from './pages/blog-detail/blog-detail.component';
import { UserLoginComponent } from './pages/user-login/user-login.component';
import { UserRegisterComponent } from './pages/user-register/user-register.component';
import { UserProfileComponent } from './pages/user-profile/user-profile.component';
import { ProductCardComponent } from './shared/product-card/product-card.component';
import { AboutComponent } from './pages/about/about.component';
import { ContactComponent } from './pages/contact/contact.component';
import { PlantDiseaseDetectorComponent } from '../plant-disease-detector/plant-disease-detector.component';


@NgModule({
  declarations: [
    ClientHeaderComponent,
    ClientFooterComponent,
    ClientHomeComponent,
    ProductsListComponent,
    ProductDetailComponent,
    CartPageComponent,
    CheckoutComponent,
    UserOrdersComponent,
    BlogListComponent,
    BlogDetailComponent,
    UserLoginComponent,
    UserRegisterComponent,
    UserProfileComponent,
    ProductCardComponent,
    AboutComponent,
    ContactComponent,
    PlantDiseaseDetectorComponent
  ],
  imports: [
    CommonModule,
    ClientRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ]
})
export class ClientModule { }
