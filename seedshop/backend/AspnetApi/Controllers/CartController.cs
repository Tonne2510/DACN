using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Cart.Request;
using AspnetApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Cart> _commonService;

        public CartController(ApiDbContext dbContext, ICommonService<Cart> commonService)
        {
            _context = dbContext;
            _commonService = commonService;
        }


        [HttpPost("search")]
        public async Task<List<CartItem>> Get([FromBody] CartRequestDTO cart1)
        {
            // Retrieve the cart for the user
            var cart = await _context.Carts.FirstOrDefaultAsync(c => c.Account.Id == cart1.UserId);
            if (cart == null)
            {
                return new List<CartItem>();
            }

            return await _context.CartItems
                .Where(ci => ci.CartId == cart.Id)
                .Include(ci => ci.Product) 
                .ToListAsync();
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddToCart([FromBody] CartRequestDTO cart)
        {
            var account = await _context.Users.FindAsync(cart.UserId);
            if (account == null)
            {
                throw new Exception("User not found.");
            }

            var product = await _context.Products.FindAsync(int.Parse(cart.ProductId));

            if (product == null)
            {
                throw new Exception("Product not found.");
            }


            Cart? item = await _context.Carts.FirstOrDefaultAsync(t => t.UserId.Equals(cart.UserId));

            if (item == null)
            {
                var cartMain = new Cart
                {
                    Account = account
                };

                await _context.Carts.AddAsync(cartMain);
                await _context.SaveChangesAsync(); // Save the cart to generate the CartId

                // Create the cart item and associate it with the cart
                var cartItem = new CartItem
                {
                    CartId = cartMain.Id, 
                    Product = product,
                    Price = float.TryParse(cart.Price, out float price) ? price : 0,
                    Quantity = int.TryParse(cart.Quantity, out int quantity) ? quantity : 1,
                };

                await _context.CartItems.AddAsync(cartItem);
                await _context.SaveChangesAsync();
                var response = new { message = "Add to cart successfully!!!" };
                return Ok(response);
            }
            else
            {
                CartItem? cartItem = await _context.CartItems.FirstOrDefaultAsync(it => it.CartId==item.Id && it.ProductId == int.Parse(cart.ProductId));

                if(cartItem != null) {

                    cartItem.Quantity += int.TryParse(cart.Quantity, out int quantity) ? quantity : 1;
                    await _context.SaveChangesAsync();
                    var response = new { message = "Add to cart successfully!!!" };
                    return Ok(response);
                }
                else
                {
                    CartItem newCartItem = new CartItem()
                    {
                        Cart = item,
                        Product = product,
                        Price = float.TryParse(cart.Price, out float price) ? price : 0,
                        Quantity = int.TryParse(cart.Quantity, out int quantity) ? quantity : 1,
                    };

                    await _context.CartItems.AddAsync(newCartItem);
                    await _context.SaveChangesAsync();
                    var response = new { message = "Add to cart successfully!!!" };
                    return Ok(response);
                }
            }
        }

        [HttpDelete]
        public async Task<IActionResult> RemoveToCart([FromBody] CartRequestDTO cart)
        {
            var cartItem = await _context.CartItems.FirstOrDefaultAsync(item => item.CartId == int.Parse(cart.CartId) && item.ProductId == int.Parse(cart.ProductId));

            if (cartItem != null) {

                 _context.Remove(cartItem);
                await _context.SaveChangesAsync();
                var response = new { message = "Remove successfully!!!" };
                return Ok(response);
            }
            return new JsonResult("Cart item not found") { StatusCode = 500 };
        }

        [HttpPost("update")]
        public async Task<IActionResult> UpdateQuantityCart([FromBody] CartRequestDTO cart)
        {
            Cart? item = await _context.Carts.FirstOrDefaultAsync(t => t.Id == int.Parse(cart.CartId));

            if (item == null)
            {
                throw new Exception("Cart not found");
            }

            var product = await _context.Products.FindAsync(int.Parse(cart.ProductId));

            if (product == null)
            {
                throw new Exception("Product not found.");
            }

            CartItem? cartItem =await _context.CartItems.FirstOrDefaultAsync(it=>it.Cart.Equals(item)&&it.Product.Equals(product));


            if (cartItem == null)
            {
                throw new Exception("Cart item not found");
            }

            cartItem.Quantity = int.Parse(cart.Quantity);
            _context.SaveChanges();
            var response = new { message = "Update quantity of product successfully!!!" };
            return Ok(response);
        }

        //xoa tat gio hang
        [HttpDelete("remove-all")]
        public async Task<IActionResult> ClearAll([FromBody] CartRequestDTO cart)
        {
            var response = new { message = "Success" };
            List<CartItem>? cartItems = await _context.CartItems.Where(item=> item.CartId.Equals(int.Parse(cart.CartId))).ToListAsync();

            if (cartItems.Count() > 0)
            {
                _context.RemoveRange(cartItems);
                await _context.SaveChangesAsync();
               
                return Ok(response);
            }
            return Ok(response);
        }

        [HttpPost("getCart")]
        public async Task<IActionResult> GetCartByUserId([FromBody] CartRequestDTO cart)
        {
            Cart? item = await _context.Carts.FirstOrDefaultAsync(t => t.UserId == cart.UserId);

            if (item == null)
            {
                throw new Exception("Cart not found");
            }

            var response = new { cartId = item.Id};

            return Ok(response);
        }
    }
}
