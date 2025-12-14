import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
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
import { AboutComponent } from './pages/about/about.component';
import { ContactComponent } from './pages/contact/contact.component';
import { PlantDiseaseDetectorComponent } from '../plant-disease-detector/plant-disease-detector.component';
import { ClientGuard } from '../../guards/client.guard';

const routes: Routes = [
  { path: '', component: ClientHomeComponent, canActivate: [ClientGuard] },
  { path: 'products', component: ProductsListComponent, canActivate: [ClientGuard] },
  { path: 'products/:slug', component: ProductDetailComponent, canActivate: [ClientGuard] },
  { path: 'cart', component: CartPageComponent, canActivate: [ClientGuard] },
  { path: 'checkout', component: CheckoutComponent, canActivate: [ClientGuard] },
  { path: 'orders', component: UserOrdersComponent, canActivate: [ClientGuard] },
  { path: 'blog', component: BlogListComponent, canActivate: [ClientGuard] },
  { path: 'blog/:slug', component: BlogDetailComponent, canActivate: [ClientGuard] },
  { path: 'login', component: UserLoginComponent },
  { path: 'register', component: UserRegisterComponent },
  { path: 'profile', component: UserProfileComponent, canActivate: [ClientGuard] },
  { path: 'about', component: AboutComponent, canActivate: [ClientGuard] },
  { path: 'contact', component: ContactComponent, canActivate: [ClientGuard] },
  { path: 'plant-disease', component: PlantDiseaseDetectorComponent, canActivate: [ClientGuard] }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ClientRoutingModule { }
