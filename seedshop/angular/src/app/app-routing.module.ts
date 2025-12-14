import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';
import { LoginAdminComponent } from './login-admin/login-admin.component';

const routes: Routes = [
  { path: 'admin', loadChildren: () => import('./components/admin/admin.module').then(m => m.AdminModule), canActivate: [AuthGuard] },
  { path: 'admin-login', component: LoginAdminComponent },
  {
    path: '',
    loadChildren: () => import('./components/client/client.module').then(m => m.ClientModule)
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, {
    anchorScrolling: 'enabled',
    scrollPositionRestoration: 'enabled',
    useHash: false,
    enableTracing: true // Enable router debug logging
  })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
