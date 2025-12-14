import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MasterviewAdminComponent } from './masterview-admin.component';

describe('MasterviewAdminComponent', () => {
  let component: MasterviewAdminComponent;
  let fixture: ComponentFixture<MasterviewAdminComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [MasterviewAdminComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(MasterviewAdminComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
