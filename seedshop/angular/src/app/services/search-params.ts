export interface SearchParams {
    pageNumber: number;
    pageSize: number;
    keyword: string;
    status: string;
    sortBy: string;
    sortDir: string;
    toPrice: number;
    fromPrice: number;
    categoryId: any;
    optionIds: number[];
  }