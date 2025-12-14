namespace AspnetApi.Dtos.Cart.Request
{
    public class CartRequestDTO
    {
        public string? UserId { get; set; }
        public string? ProductId { get; set; }
        public string? Quantity { get; set; }
        public string? Price { get; set; }
        public string? CartId {  get; set; }

    }
}
