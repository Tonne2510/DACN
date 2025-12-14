using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Attribute.Request;
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
    public class AttributeController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<AttributeC> _commonService;

        public AttributeController(ApiDbContext dbContext, ICommonService<AttributeC> commonService)
        {
            _context = dbContext;
            _commonService = commonService;
        }
        [Authorize(Roles = "Admin, Manager")]

        [HttpPost("search")]
        public async Task<IActionResult> Get([FromBody] QueryParams queryParams)
        {
            var query = _context.Attributes.AsQueryable();

            var pagedResponse = await _commonService.GetPagedDataAsync(queryParams, new[] { "AttributeName" });

            return Ok(pagedResponse);
        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            AttributeC? item = await _context.Attributes.FirstOrDefaultAsync(t => t.Id == id);

            if (item == null)
            {
                return new JsonResult("Attribute id Not found") { StatusCode = 400 };
            }

            return Ok(item);

        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpPost]
        public async Task<IActionResult> Add(CreateAttributeDTO attribute)
        {
            var checkExist = await _context.Attributes.FirstOrDefaultAsync(ct => ct.AttributeName.Equals(attribute.AttributeName) || ct.AttributeCode.Equals(attribute.AttributeCode));
            if (checkExist != null)
            {
                return new JsonResult("Attribute is existed") { StatusCode = 400 };
            }

            if (!attribute.Equals(null))
            {
                AttributeC item = new AttributeC()
                {
                    AttributeCode = attribute.AttributeCode,
                    AttributeName = attribute.AttributeName,
                    Slug = SlugHelper.GenerateSlug(attribute.AttributeName)
                };
                await _context.Attributes.AddAsync(item);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetById", new { item.Id }, attribute);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, UpdateAttributeDTO attribute)
        {
            AttributeC? exist = await _context.Attributes.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Attribute with ID: {id} not found");
            }

            if (ModelState.IsValid)
            {
                exist.AttributeCode = attribute.AttributeCode;
                exist.AttributeName = attribute.AttributeName;
                exist.Slug = SlugHelper.GenerateSlug(attribute.AttributeName);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            AttributeC? exist = await _context.Attributes.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Attribute with ID: {id} not found");

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
