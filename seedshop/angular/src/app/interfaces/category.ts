import { Product } from "./product";

export interface Category {
  id?: number;
  categoryName: string;
  active: string;
  slug?: string;    
  products?: Product[];
  }
  