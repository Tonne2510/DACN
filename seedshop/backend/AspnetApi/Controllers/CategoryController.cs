using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Category.Request;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Category> _commonService;

        public CategoryController(ApiDbContext dbContext, ICommonService<Category> commonService)
        {
            _context = dbContext;
            _commonService = commonService;
        }

        [HttpPost("search")]
        [AllowAnonymous]
        public async Task<IActionResult> Get([FromBody] QueryParams queryParams)
        {
            var query = _context.Categories.AsQueryable();

            var pagedResponse = await _commonService.GetPagedDataAsync(queryParams, new[] { "CategoryName" });

            return Ok(pagedResponse);
        }
        [HttpGet("all")]
        [AllowAnonymous]
        public async Task<IActionResult> GetAllCategories()
        {
            var categories = await _context.Categories.Include(c => c.Products).ToListAsync();
            return Ok(categories);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            Category? item = await _context.Categories.FirstOrDefaultAsync(t => t.Id == id);

            if (item == null)
            {
                return new JsonResult("Category id Not found") { StatusCode = 400 };
            }

            return Ok(item);

        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Add(CategoryDTO category)
        {
            var checkExist = await _context.Categories.FirstOrDefaultAsync(ct => ct.CategoryName.Equals(category.CategoryName));
            if (checkExist != null)
            {
                return new JsonResult("Category is existed") { StatusCode = 400 };
            }

            if (!category.Equals(null))
            {
                Category item = new Category()
                {
                    Active = category.Active.Equals("1") ? true : false,
                    CategoryName = category.CategoryName,
                    Slug = SlugHelper.GenerateSlug(category.CategoryName)
                };
                await _context.Categories.AddAsync(item);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetById", new { item.Id }, category);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateCategoryDTO category)
        {
            Category? exist = await _context.Categories.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Category with ID: {id} not found");
            }

            if (ModelState.IsValid)
            {
                exist.Active = category.Active.Equals("1") ? true : false;
                exist.CategoryName = category.CategoryName;
                exist.Slug = SlugHelper.GenerateSlug(category.CategoryName);

                await _context.SaveChangesAsync();

                return Ok(exist);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            Category? exist = await _context.Categories.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Category with ID: {id} not found");

            if (ModelState.IsValid)
            {
                _context.Remove(exist);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }
            return new JsonResult("Something went wrong") { StatusCode = 500 };

        }
        [Authorize(Roles = "Admin")]
        [HttpGet("checkNameExists")]
        public async Task<IActionResult> CheckNameExists([FromQuery] string name)
        {
            try
            {
                var exists = await _context.Categories.AnyAsync(c => c.CategoryName == name);
                return Ok(exists);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Internal server error. Please try again later.");
            }
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("hasProducts/{id}")]
        public async Task<IActionResult> HasProducts(int id)
        {
            var hasProducts = await _context.Products.AnyAsync(p => p.CategoryId == id);
            return Ok(hasProducts);
        }


    }
}
