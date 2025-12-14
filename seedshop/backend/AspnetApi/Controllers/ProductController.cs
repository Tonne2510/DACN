using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Product;
using AspnetApi.Dtos.Product.Request;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Product> _commonService;
        private readonly ILogger<ProductController> _logger;

        private readonly UserManager<Account> _userManager;

        public ProductController(ApiDbContext dbContext, ICommonService<Product> commonService, UserManager<Account> userManager, ILogger<ProductController> logger)
        {
            _context = dbContext;
            _commonService = commonService;
            _userManager = userManager;
            _logger = logger;
        }

        [HttpPost("search")]
        [AllowAnonymous]
        public async Task<IActionResult> Get([FromBody] SearchProductFilter queryParams)
        {
            var query = _context.Products.AsQueryable();

            var includeFunc = new Func<IQueryable<Product>, IQueryable<Product>>(query =>
               query.Include(p => p.Category)
           );

            var pagedResponse = await _commonService.SearchProduct(queryParams, new[] { "ProductName" }, includeFunc);

            return Ok(pagedResponse);
        }
        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetById(int id)
        {
            Product? item = await _context.Products.Include(p=>p.Category).FirstOrDefaultAsync(t => t.Id==id);

            if (item == null)
            {
                return new JsonResult("Product id Not found") { StatusCode = 400 };
            }

            return Ok(item);

        }
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Add([FromForm] CreateProductDTO prod)
        {
            // Kiểm tra tồn tại sản phẩm
            var checkExist = await _context.Products
                .FirstOrDefaultAsync(ct => ct.ProductName.Equals(prod.ProductName));

            if (checkExist != null)
            {
                return new JsonResult("Product name is existed") { StatusCode = 400 };
            }

            // Upload ảnh
            var imageProduct = await _commonService.UploadFile(prod.Image);
            string json = prod.Album != null
                ? JsonSerializer.Serialize(await _commonService.UploadFiles(prod.Album))
                : null;

            if (prod != null)
            {
                var item = new Product
                {
                    Price = prod.Price,
                    ProductName = prod.ProductName,
                    SalePrice = prod.SalePrice,
                    Category = await _context.Categories.FindAsync(prod.CategoryId),
                    Description = prod.Description,
                    Active = prod.Active?.Equals("1") == true,
                    Image = imageProduct,
                    Slug = SlugHelper.GenerateSlug(prod.ProductName),
                    Album = json
                };

                await _context.Products.AddAsync(item);
                await _context.SaveChangesAsync();

                // Xử lý thuộc tính
                if (prod.Attributes != null && prod.Attributes!="[]")
                {
                    var list = JsonSerializer.Deserialize<List<object>>(prod.Attributes);
                    var myClassList = ConvertToClassList<AttributeOptionDto>(list);
                    var optionIds = myClassList
                         .Select(attr =>
                         {
                             int parsedId;
                             return int.TryParse(attr.OptionId, out parsedId) ? parsedId : (int?)null;
                         })
                         .Where(id => id.HasValue)
                         .Select(id => id.Value)
                         .ToList();

                    // Ensure no complex queries are involved, and execute a simpler query to isolate the issue
                    // Convert the list of OptionIds to a comma-separated string
                    string optionIdsString = string.Join(",", optionIds);

                    // Your SQL query, utilizing the SplitString function
                    string query = @"
                    ;WITH CTE AS (
                        SELECT * 
                        FROM AttributeOptions 
                        WHERE Id IN (
                            SELECT Item 
                            FROM dbo.SplitString(@OptionIds, ',')
                        )
                    )
                    SELECT * FROM CTE";

                    var attributeOptionExists = await _context.AttributeOptions
                        .FromSqlRaw(query, new SqlParameter("@OptionIds", optionIdsString))
                        .ToListAsync();
                    if (attributeOptionExists.Count != myClassList.Count)
                    {
                        return new JsonResult("One or more OptionIds do not exist") { StatusCode = 400 };
                    }

                    var attributes = myClassList.Select(attr => new AttributeOptionProduct
                    {
                        ProductId = item.Id,
                        AttributeOptionId = int.Parse(attr.OptionId)
                    }).ToList();

                    await _context.AttributeOptionProducts.AddRangeAsync(attributes);
                    await _context.SaveChangesAsync();
                }

                return CreatedAtAction("GetById", new { item.Id }, prod);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        static List<T> ConvertToClassList<T>(List<object> objectList)
        {
            var json = JsonSerializer.Serialize(objectList);
            return JsonSerializer.Deserialize<List<T>>(json);
        }
            [Authorize(Roles = "Admin")]
            [HttpPut("{id}")]
            public async Task<IActionResult> Update(int id, [FromForm] UpdateProductDTO prod)
            {
                try
                {
                    Product? exist = await _context.Products.FirstOrDefaultAsync(t => t.Id == id);

                    if (exist == null)
                    {
                        return NotFound($"Product with ID: {id} not found");
                    }
                    var imageProduct = await _commonService.UploadFile(prod.Image);

                    List<string> oldImages = string.IsNullOrEmpty(prod.OldImage)
                        ? new List<string>()
                        : JsonSerializer.Deserialize<List<string>>(prod.OldImage);

                    string json = "";
                    if (prod.Album != null && prod.Album.Count > 0)
                    {
                        List<string> images = await _commonService.UploadFiles(prod.Album);
                        oldImages.AddRange(images);
                        json = JsonSerializer.Serialize(oldImages);
                    }
                    else
                    {
                        json = JsonSerializer.Serialize(oldImages);
                    }

                    if (ModelState.IsValid)
                    {
                        exist.ProductName = prod.ProductName;
                        exist.Price = prod.Price;
                        exist.SalePrice = prod.SalePrice;
                        exist.Category = await _context.Categories.FindAsync(prod.CategoryId);
                        exist.Description = prod.Description;
                        exist.Active = prod.Active != null && prod.Active.Equals("1");
                        exist.Slug = SlugHelper.GenerateSlug(prod.ProductName);

                        if (!string.IsNullOrEmpty(imageProduct))
                        {
                            exist.Image = imageProduct;
                        }

                        if (!string.IsNullOrEmpty(json))
                        {
                            exist.Album = json;
                        }

                        await _context.SaveChangesAsync();
                        return Ok(exist);
                    }

                    return BadRequest("Invalid data");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error updating product with ID: {Id}", id);
                    return StatusCode(500, "An internal error occurred");
                }
            }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            Product? exist = await _context.Products.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Product with ID: {id} not found");

            if (ModelState.IsValid)
            {
                _context.Remove(exist);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }
            return new JsonResult("Something went wrong") { StatusCode = 500 };

        }

    }
}
