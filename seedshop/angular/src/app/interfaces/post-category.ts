import { Post } from "./post";

export interface PostCategory {
    id?: any;
    active: string;
    postCategoryName: string;
    slug?: string;    
    posts?: Post[];
  }