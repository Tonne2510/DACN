namespace AspnetApi.Dtos.Order.Response
{
    public class OrderDetailResponse
    {
        public int OrderId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public bool? Gender { get; set; }
        public string? Avatar {  get; set; }
        public string Phone { get; set; }
        public DateTime? OrderDate { get; set; }
        public string ShippingAddress { get; set; }

        public string Status { get; set; }
        public List<OrderItemDetail> OrderItems { get; set; }
        public float TotalPrice { get; set; }
    }
}
