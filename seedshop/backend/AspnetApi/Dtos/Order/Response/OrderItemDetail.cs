namespace AspnetApi.Dtos.Order.Response
{
    public class OrderItemDetail
    {
        public string ProductName { get; set; }
        public int Quantity { get; set; }
        public float Price { get; set; }
        public float SubTotal => Quantity * Price; 
    }
}
