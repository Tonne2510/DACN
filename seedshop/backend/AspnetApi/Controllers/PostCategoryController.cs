using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Category.Request;
using AspnetApi.Dtos.PostCategory.Request;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class PostCategoryController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<PostCategory> _commonService;

        public PostCategoryController(ApiDbContext dbContext, ICommonService<PostCategory> commonService)
        {
            _context = dbContext;
            _commonService = commonService;
        }
        [AllowAnonymous]
        //[Authorize(Roles = "Admin")]

        [HttpPost("search")]
        public async Task<IActionResult> Get([FromBody] QueryParams queryParams)
        {
            var query = _context.PostCategories.AsQueryable();

            var pagedResponse = await _commonService.GetPagedDataAsync(queryParams, new[] { "PostCategoryName" });

            return Ok(pagedResponse);
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            PostCategory? item = await _context.PostCategories.FirstOrDefaultAsync(t => t.Id == id);

            if (item == null)
            {
                return new JsonResult("Post category id Not found") { StatusCode = 400 };
            }

            return Ok(item);

        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Add(CreatePostCategoryDTO postCategory)
        {
            var checkExist = await _context.PostCategories.FirstOrDefaultAsync(ct => ct.PostCategoryName.Equals(postCategory.PostCategoryName));
            if (checkExist != null)
            {
                return new JsonResult("Post Category is existed") { StatusCode = 400 };
            }

            if (!postCategory.Equals(null))
            {
                PostCategory item = new PostCategory()
                {
                    Active = postCategory.Active.Equals("1") ? true : false,
                    PostCategoryName = postCategory.PostCategoryName,
                    Slug = SlugHelper.GenerateSlug(postCategory.PostCategoryName)
                };
                await _context.PostCategories.AddAsync(item);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetById", new { item.Id }, postCategory);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdatePostCategoryDTO postCategory)
        {
            PostCategory? exist = await _context.PostCategories.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Post Category with ID: {id} not found");
            }

            if (ModelState.IsValid)
            {
                exist.Active = postCategory.Active.Equals("1") ? true : false;
                exist.PostCategoryName = postCategory.PostCategoryName;
                exist.Slug = SlugHelper.GenerateSlug(postCategory.PostCategoryName);

                await _context.SaveChangesAsync();

                return Ok(exist);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            PostCategory? exist = await _context.PostCategories.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Post Category with ID: {id} not found");

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
