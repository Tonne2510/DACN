using AspnetApi.Models;

namespace AspnetApi.Dtos.Cart.Response
{
    public class CartItemRequestDTO
    {
        public float TotalAmount { get; set; }
        public List<CartItem> CartItems { get; set; }

    }
}
