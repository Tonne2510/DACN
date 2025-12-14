using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Order;
using AspnetApi.Dtos.Order.Request;
using AspnetApi.Dtos.Order.Response;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Order> _commonService;

        public OrderController(ApiDbContext context, ICommonService<Order> commonService)
        {
            _context = context;
            _commonService = commonService;
        }

        // Create a new order
        [HttpPost("create")]
        public async Task<IActionResult> CreateOrder(Order order)
        {
            // Fetch the cart for the user
            var cart = await _context.Carts
                .Include(c => c.CartItems) // Ensure cart items are loaded
                .FirstOrDefaultAsync(c => c.UserId.Equals(order.UserId));

            if (cart == null)
            {
                return NotFound(new { message = "Cart not found for the user." });
            }

            // Retrieve cart items
            var cartItems = cart.CartItems.ToList();

            if (cartItems.Count == 0)
            {
                return new JsonResult("No products in the cart.");
            }

            // Add the order
            _context.Order.Add(order);
            await _context.SaveChangesAsync(); // Save changes to generate order Id

            // Create OrderItems from CartItems
            var orderItems = cartItems.Select(item => new OrderItem
            {
                OrderId = order.Id,
                ProductId = item.ProductId,
                Quantity = item.Quantity,
                Price = item.Price
            }).ToList();

            // Add OrderItems to the database
            await _context.OrderItems.AddRangeAsync(orderItems);
            await _context.SaveChangesAsync();

            // Remove cart items for the user
            _context.CartItems.RemoveRange(cartItems);
            await _context.SaveChangesAsync();

            return Ok(order);
        }

        // Remove an order
        [HttpDelete("remove/{id}")]
        public async Task<IActionResult> RemoveOrder(int id)
        {
            var order = await _context.Order.FindAsync(id);
            if (order == null) return NotFound();

            _context.Order.Remove(order);
            await _context.SaveChangesAsync();
            return Ok();
        }

        // Change order status
        [HttpPut("change-status/{id}")]
        public async Task<IActionResult> ChangeStatus(int id, [FromBody] OrderChangeStatusRequest orderChange)
        {
            var order = await _context.Order.FindAsync(id);
            if (order == null) return NotFound();

            // Check if the status transition is valid
            if (!IsValidStatusTransition(order.Status, orderChange.NewStatus))
            {
                throw new Exception("Lỗi chuyển đổi trạng thái !");
            };
            order.Status = orderChange.NewStatus.ToString();
            _context.Order.Update(order);
            await _context.SaveChangesAsync();
            return Ok(order);
        }

        // Get orders by user ID
        [HttpGet("user-orders/{userId}")]
        public async Task<IActionResult> GetUserOrders(string userId)
        {
            //var orders = await _context.Order.Where(o => o.UserId == userId).Include(o=>o.Account).Include(o=>o.OrderItems).ThenInclude(p=>p.Product).ToListAsync();
            var orders = await _context.Order
            .Where(o => o.UserId == userId)
            .Include(o => o.Account)
            .Include(o => o.OrderItems)
                .ThenInclude(p => p.Product)
            .OrderByDescending(o => o.Id) // Sorting by Id in descending order
            .ToListAsync();
            // Project the data to include computed fields
            var orderResponses = orders.Select(order => new OrderDetailResponse
            {
                OrderId = order.Id,
                OrderDate = order.OrderDate,
                Status = order.Status,
                ShippingAddress = order.ShippingAddress,
                UserName = order.Account.UserName,
                Email = order.Account.Email,
                OrderItems = order.OrderItems.Select(orderItem => new OrderItemDetail
                {
                    ProductName = orderItem.Product.ProductName,
                    Quantity = orderItem.Quantity,
                    Price = orderItem.Price
                }).ToList(),
                TotalPrice = order.OrderItems.Sum(item => item.Quantity * item.Price) // Computed field
            }).ToList();

            return Ok(orderResponses);
        }

        //getAll order at admin area
        //note check again
        [HttpPost("search")]
        public async Task<IActionResult> Get([FromBody] QueryParams queryParams)
        {
             // Define the query and include related entities
              var query = _context.Order.AsQueryable();
            var includeFunc = new Func<IQueryable<Order>, IQueryable<Order>>(query =>
          query.Include(o => o.Account)
             .Include(o => o.OrderItems)
                 .ThenInclude(oi => oi.Product));
            // Get paged data from the common service
            var pagedData = await _commonService.GetPagedDataAsync(queryParams, new[] { "" }, includeFunc);
            var projectedItems = pagedData.Data.Select(order => new OrderDetailResponse
            {
                OrderId = order.Id,
                OrderDate = order.OrderDate,
                Status = order.Status,
                ShippingAddress = order.ShippingAddress,
                UserName = order.Account.UserName,
                Email = order.Account.Email,
                OrderItems =order.OrderItems.Select(item=>new OrderItemDetail
                { 
                    ProductName = item.Product.ProductName,
                    Quantity = item.Quantity,
                    Price = item.Price,
                }).ToList(),
                TotalPrice = order.OrderItems.Sum(oi => oi.Quantity * oi.Price)
            }).ToList();



            PageResponseOrder response = new PageResponseOrder(pagedData.PageNumber, pagedData.PageSize, pagedData.TotalRecords, projectedItems);
         
            return Ok(response);
        
        }

        //detail order get information of the account and product totalPrice
        [HttpGet("detail/{orderId}")]
        public async Task<IActionResult> GetOrderDetail(int orderId)
        {
            // Retrieve the order along with related entities
            var order = await _context.Order
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.Product)
                .Include(o => o.Account)
                .FirstOrDefaultAsync(o => o.Id == orderId);

            // Return 404 if the order does not exist
            if (order == null) return NotFound(new { message = "Order not found" });

            // Create the response model
            var orderDetailResponse = new OrderDetailResponse
            {
                OrderId = order.Id,
                UserName = order.Account?.UserName ?? "Unknown",
                Email = order.Account?.Email ?? "Unknown",
                Phone = order.Account.PhoneNumber,
                Gender = order.Account.Gender,
                Avatar = order.Account.Avatar,
                OrderDate = order.OrderDate,
                Status = order.Status,
                ShippingAddress = order.ShippingAddress,
                OrderItems = order.OrderItems.Select(oi => new OrderItemDetail
                {
                    ProductName = oi.Product?.ProductName ?? "Unknown Product",
                    Quantity = oi.Quantity,
                    Price = oi.Price
                }).ToList(),
                TotalPrice = order.OrderItems.Sum(oi => oi.Quantity * oi.Price)
            };

            // Return the response
            return Ok(orderDetailResponse);
        }

        private bool IsValidStatusTransition(string currentStatus, string newStatus)
        {
            // Implement status transition rules
            switch (currentStatus)
            {
                case nameof(OrderStatus.Ordered):
                    return newStatus == "Shipping";
                case nameof(OrderStatus.Shipping):
                    return newStatus == "Delivered";
                case nameof(OrderStatus.Delivered):
                    return false; // No further status changes allowed
                default:
                    return false;
            }
        }
    }
}
