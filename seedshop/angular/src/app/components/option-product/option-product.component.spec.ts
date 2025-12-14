import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OptionProductComponent } from './option-product.component';

describe('OptionProductComponent', () => {
  let component: OptionProductComponent;
  let fixture: ComponentFixture<OptionProductComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [OptionProductComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(OptionProductComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
