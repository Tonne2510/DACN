import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AttributeProductComponent } from './attribute-product.component';

describe('AttributeProductComponent', () => {
  let component: AttributeProductComponent;
  let fixture: ComponentFixture<AttributeProductComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AttributeProductComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AttributeProductComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
