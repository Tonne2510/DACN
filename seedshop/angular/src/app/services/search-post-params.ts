export interface SearchPostParams {
    PageNumber: number;
    PageSize: number;
    Keyword: string;
    Status: string;
    SortBy: string;
    SortDir: string;
    PostCategoryId?: string;
    IsPublish?: string;
  }
  export interface SearchCommentParams {
    pageNumber: number;
    pageSize: number;
    keyword: string;
    status: string;
    sortBy: string;
    sortDir: string;
    startDate: string,
    endDate: string,
    isActive:string
  }
