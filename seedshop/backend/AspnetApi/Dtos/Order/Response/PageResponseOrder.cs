namespace AspnetApi.Dtos.Order.Response
{
    public class PageResponseOrder
    {
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public List<OrderDetailResponse> Data { get; set; }

        public PageResponseOrder(int pageNumber, int pageSize, int totalRecords, List<OrderDetailResponse> data)
        {
            PageNumber = pageNumber;
            PageSize = pageSize;
            TotalRecords = totalRecords;
            Data = data;
        }
    }
}
