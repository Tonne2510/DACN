import { PostCategory } from "./post-category";

export interface Post {
    id: number,
    title:string,
    description: string,
    postCategoryId: number,
    postCategory: PostCategory,
    content: string,
    status: string,
    slug: string,
    image: string,
    createdAt: string,
    updatedAt: string,
    imageUrl:string
}

